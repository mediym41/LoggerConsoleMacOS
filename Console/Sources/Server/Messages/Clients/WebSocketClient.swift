//
//  WebSocketClient.swift
//  Console
//
//  Created by Дмитрий Пащенко on 05.11.2021.
//

import Vapor

final class WebSocketClient {
    var id: UUID
    var socket: WebSocket
    
    init(id: UUID = .init(), socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
}

