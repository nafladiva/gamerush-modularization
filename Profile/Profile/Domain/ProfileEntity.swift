//
//  ProfileEntity.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 24/11/24.
//

import Foundation

public struct ProfileEntity {
    public static let nameKey = "name"
    public static let emailKey = "email"

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
