//
//  ViewContext.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import MisskeyKit
import SwiftKit
import SwiftUI
import Combine

class ViewContext: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewContext,Never>()
    
    init() {
        self.refreshContext() // Load inital data
    }
    
    // MARK: User Information
    
    var currentUser: UserModel? = nil {
        didSet {
            withAnimation {
                DispatchQueue.main.async {
                    self.objectWillChange.send(self)
                }
            }
        }
    }
    
    var currentUserId: String  {
        get {
            self.currentUser?.id ?? ""
        }
    }
    
    // MARK: Instance Information
    
    var currentInstance: MetaModel? = nil {
        didSet {
            withAnimation {
                DispatchQueue.main.async {
                    self.objectWillChange.send(self)
                }
            }
        }
    }
    
    var currentInstanceName: String  {
        get {
            self.currentInstance?.name ?? "rawr."
        }
    }
    
    // MARK: Default Emojis
    var defaultEmojis: [DefaultEmojiModel] = [] {
        didSet {
            withAnimation {
                DispatchQueue.main.async {
                    self.objectWillChange.send(self)
                }
            }
        }
    }
    
    // MARK: Application Customization
    
    var themeBackground: some View {
        get {
//            FluentBackground.Rainbow
            Color.background
//            FluentBackground.Aurora
        }
    }
    
    // MARK: Helpers
    
    var applicationReady: Bool {
        get {
            self.currentUser != nil && self.currentInstance != nil
        }
    }
    
    // MARK: Global Error Handler
    var applicationError: ApplicationError? {
        didSet {
            withAnimation {
                DispatchQueue.main.async {
                    self.objectWillChange.send(self)
                }
            }
        }
    }
    
    
    /// Check whether the current application state considers the user logged in
    var loggedIn: Bool = false {
        didSet {
            withAnimation {
                DispatchQueue.main.async {
                    self.objectWillChange.send(self)
                }
            }
        }
    }
    
    /// Trigger a re-draw of all the active views that are listening to this application context object
    func refreshViews() {
        withAnimation {
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
        }
    }
    
    /// Force an assessment of the current situation and update the context properties accordingly
    func refreshContext() {
        MisskeyKit.shared.changeInstance(instance: RawrKeychain().instanceHostname)
        self.loggedIn = RawrKeychain().loggedIn
        if RawrKeychain().loggedIn {
            MisskeyKit.shared.auth.setAPIKey(RawrKeychain().apiKey!)
            MisskeyKit.shared.users.i { userModel, _ in
                guard let userModel = userModel else {
                    return
                }
                self.currentUser = userModel
            }
            MisskeyKit.shared.meta.get { meta, _ in
                guard let meta = meta else {
                    return
                }
                self.currentInstance = meta
            }
            MisskeyKit.shared.emojis.getDefault { emojis in
                guard let emojis = emojis else {
                    return
                }
                self.defaultEmojis = emojis
            }
        }
    }
}

struct ApplicationError {
    let title: String
    let message: String
}
