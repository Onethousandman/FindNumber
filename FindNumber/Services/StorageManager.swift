//
//  StorageManager.swift
//  FindNumber
//
//  Created by Никита Тыщенко on 06.08.2024.
//

import Foundation

enum KeysUserDefaults: String {
    case timeValue
    case timerState
    case recordGame
}

final class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func save<T: Codable>(key: String, value: T) {
        let data = try? JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
