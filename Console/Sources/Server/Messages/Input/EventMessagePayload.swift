//
//  EventMessage.swift
//  Console
//
//  Created by Дмитрий Пащенко on 05.11.2021.
//

import Foundation

struct EventMessagePayload: Decodable {
    var message: String
    var marker: [String]
    var json: JsonRepresentable?
    var level: LogLevel
}



