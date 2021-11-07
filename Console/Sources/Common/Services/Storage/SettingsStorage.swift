//
//  SettingsStorage.swift
//  Console
//
//  Created by Дмитрий Пащенко on 07.11.2021.
//

import Foundation

protocol SettingsStorageProtocol {
    var host: String { get set }
    var port: String { get set }
}

struct SettingsStorage {
    @UserDefault("settings.connection.host", defaultValue: "127.0.0.1")
    var host: String
    
    @UserDefault("settings.connection.port", defaultValue: "8080")
    var port: String
}
