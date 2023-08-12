//
//  RawrKeychain.swift
//  Derg Social
//
//  Created by Nila on 12.08.2023.
//

import Foundation
import KeychainSwift

internal enum KeychainKeys: String {
    case apiKey = "apiKey"
    case instanceHostname = "instanceHostname"
}

class RawrKeychain {
    private let keychainAccessGroup: String = "YR8RBAQQAV.co.infinytum.rawr"
    
    private let keychain: KeychainSwift
    init() {
        self.keychain = KeychainSwift()
        self.keychain.accessGroup = self.keychainAccessGroup
        self.keychain.synchronizable = true
    }
    
    var apiKey: String? {
        get {
            return self.keychain.get(KeychainKeys.apiKey.rawValue)
        }
        set {
            guard let newValue = newValue else {
                self.keychain.delete(KeychainKeys.apiKey.rawValue)
                return
            }
            self.keychain.set(newValue, forKey: KeychainKeys.apiKey.rawValue, withAccess: .accessibleAfterFirstUnlock)
        }
    }
    
    var instanceHostname: String {
        get {
            return self.keychain.get(KeychainKeys.instanceHostname.rawValue) ?? "derg.social"
        }
        set {
            self.keychain.set(newValue, forKey: KeychainKeys.instanceHostname.rawValue, withAccess: .accessibleAfterFirstUnlock)
        }
    }
    
    var loggedIn: Bool {
        return self.apiKey != nil
    }
}
