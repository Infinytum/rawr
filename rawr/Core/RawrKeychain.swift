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
    case instanceClientId = "clientId"
    case instanceClientSecret = "clientSecret"
}

class RawrKeychain {
    private let keychain: KeychainSwift
    init() {
        self.keychain = KeychainSwift()
        self.keychain.synchronizable = true
    }
    
    var apiKey: String? {
        get {
            return apiKeyForInstance(self.instanceHostname)
        }
        set {
            setApiKeyForInstance(self.instanceHostname, apiKey: newValue)
        }
    }
    
    var instanceCredentials: InstanceCredentials? {
        get {
            return credentialsForInstance(self.instanceHostname)
        }
        set {
            setCredentialsForInstance(self.instanceHostname, credentials: newValue)
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
    
    /// Instance-specific helper
    
    public func apiKeyForInstance(_ instance: String) -> String? {
        return self.keychain.get("\(KeychainKeys.apiKey.rawValue).\(instance.sha256())")
    }
    
    public func credentialsForInstance(_ instance: String) -> InstanceCredentials? {
        guard let clientSecret = self.keychain.get("\(KeychainKeys.instanceClientSecret.rawValue).\(instance.sha256())"), let clientId = self.keychain.get("\(KeychainKeys.instanceClientId.rawValue).\(instance.sha256())") else {
            return nil
        }
        
        return InstanceCredentials(
            clientId: clientId,
            clientSecret: clientSecret
        )
    }
    
    public func setApiKeyForInstance(_ instance: String, apiKey: String?) {
        guard let apiKey = apiKey else {
            self.keychain.delete("\(KeychainKeys.apiKey.rawValue).\(instance.sha256())")
            return
        }
        self.keychain.set(apiKey, forKey: "\(KeychainKeys.apiKey.rawValue).\(instance.sha256())", withAccess: .accessibleAfterFirstUnlock)
    }
    
    public func setCredentialsForInstance(_ instance: String, credentials: InstanceCredentials?) {
        guard let credentials = credentials else {
            self.keychain.delete("\(KeychainKeys.instanceClientId.rawValue).\(instance.sha256())")
            self.keychain.delete("\(KeychainKeys.instanceClientSecret.rawValue).\(instance.sha256())")
            return
        }
        self.keychain.set(credentials.clientId, forKey: "\(KeychainKeys.instanceClientId.rawValue).\(instance.sha256())", withAccess: .accessibleAfterFirstUnlock)
        self.keychain.set(credentials.clientSecret, forKey: "\(KeychainKeys.instanceClientSecret.rawValue).\(instance.sha256())", withAccess: .accessibleAfterFirstUnlock)
    }
}
