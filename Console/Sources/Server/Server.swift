//
//  Server.swift
//  Console
//
//  Created by Дмитрий Пащенко on 05.11.2021.
//

import Vapor
import Combine

final class Server {
    enum Status: Equatable {
        case inactive
        case waiting
        case connected
        case failed(String)
        
        var isRunning: Bool {
            return [.waiting, .connected].contains(self)
        }
        
        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
            case (.inactive, .inactive),
                 (.waiting, .waiting),
                 (.connected, .connected),
                 (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
    static var shared: Server = Server()
    
    // MARK: Services
    private let settingsStorage: SettingsStorage = .init()
    
    // MARK: Connection
    var app: Application?
    var clients: [WebSocketClient] = []
    
    // MARK: State
    @Published var status: Status = .inactive
    public var eventMessages: PassthroughSubject<EventMessagePayload, Never> = .init()
    
    // MARK: Constants
    let defaultPort: Int = 8080
    
    private init() {

    }
    
    deinit {
        guard status.isRunning else { return }
        stop()
    }
    
    func reload() {
        if status.isRunning {
            stop()
        }
        start()
    }
    
    func start() {
        app = .init(Environment(name: "development", arguments: ["/"]))
        guard let app = app else { return }
        app.http.server.configuration.hostname = settingsStorage.host
        app.http.server.configuration.port = Int(settingsStorage.port) ?? defaultPort
        
        route(app: app)
        
        do {
            try app.start()
            status = .waiting
        } catch {
            status = .failed(error.localizedDescription)
        }
    }
    
    func stop() {
        app?.shutdown()
        status = .inactive
    }
    
    func killAllClosedConnections() {
        clients.removeAll(where: { $0.socket.isClosed })
        
        if status == .connected && clients.isEmpty {
            status = .waiting
        }
    }
}

private extension Server {
    
    func route(app: Application) {
        app.webSocket("logger") { req, ws in
            ws.onText { ws, text in
                guard let data = text.data(using: .utf8) else {
                    self.close(webSocket: ws)
                    return
                }
                
                self.handleRequest(data: data, ws: ws)
            }

            ws.onBinary { ws, byteBuffer in
                let data = Data(buffer: byteBuffer)
                self.handleRequest(data: data, ws: ws)
            }
        }
    }
    
    func handleRequest(data: Data, ws: WebSocket) {
        let jsonDecoder: JSONDecoder = .init()
        let kind: WebSocketRequestKind
        
        do {
            kind = try jsonDecoder.decode(KindInWebSocketRequest.self, from: data).value
        } catch {
            print("Failed to handle request")
            close(webSocket: ws)
            return
        }
        
        switch kind {
        case .connect:
            guard let payload = data.decodeWebSocketRequest(ConnectPayload.self) else {
                close(webSocket: ws)
                return
            }
            
            if payload.data.connect {
                let client = WebSocketClient(id: payload.client, socket: ws)
                clients.append(client)
            } else {
                clients.removeAll(where: { $0.id == payload.client })
                close(webSocket: ws)
            }
            
            if status.isRunning {
                status = clients.isEmpty ? .waiting : .connected
            }
            
        case .eventMessage:
            guard let payload = data.decodeWebSocketRequest(EventMessagePayload.self) else {
                close(webSocket: ws)
                return
            }
            
            eventMessages.send(payload.data)
        }
    }
}


// MARK: Helpers
private extension Server {
    func close(webSocket: WebSocket) {
        print("Closed")
        _ = webSocket.close(code: .protocolError)
        killAllClosedConnections()
    }
}

// Connect
// {"client":"C7D47F56-D378-491D-8953-D9EBFFB2AD85", "data": {"connect": true}, "kind":"connect"}

// Disconnect
// {"client":"C7D47F56-D378-491D-8953-D9EBFFB2AD85", "data": {"connect": false}, "kind":"connect"}

// Event Message Payload
// {"client":"C7D47F56-D378-491D-8953-D9EBFFB2AD85", "data": {"message":"Owwo! Some shit happens!","marker":["Network","KMM"],"json":{"request":"Graph authoriation social provider failed","social_provider":"Facebook","count":5,"is_fatal":false},"level":"error"}, "kind":"eventMessage"}
