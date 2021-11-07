//
//  WebSocketRequest.swift
//  Console
//
//  Created by Дмитрий Пащенко on 05.11.2021.
//

import Foundation
import Vapor

enum WebSocketRequestKind: String, Decodable {
    case connect
    case eventMessage
}

struct KindInWebSocketRequest: Decodable {
    var value: WebSocketRequestKind
    
    enum CodingKeys: String, CodingKey {
        case value = "kind"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(WebSocketRequestKind.self, forKey: .value)
    }
}

struct WebSocketRequest<T: Decodable>: Decodable {
    var client: UUID
    var data: T
}


extension Data {
    func decodeWebSocketRequest<T: Decodable>(_ type: T.Type) -> WebSocketRequest<T>? {
        do {
            return try JSONDecoder().decode(WebSocketRequest<T>.self, from: self)
        } catch {
            print("Failed to decode request of type: \(type), reason: \(error)")
            return nil
        }
    }
}
