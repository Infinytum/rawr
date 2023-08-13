//
//  ViewContext.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import MisskeyKit
import SwiftUI
import Combine

class ViewContext: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewContext,Never>()
    
    init() {
        self.refreshContext() // Load inital data
    }
    
    var currentUser: UserModel? = nil {
        didSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
    
    var currentUserId: String = "" {
        didSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
    
    /// Check whether the current application state considers the user logged in
    var loggedIn: Bool = false {
        didSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
    
    /// Trigger a re-draw of all the active views that are listening to this application context object
    func refreshViews() {
        withAnimation {
            objectWillChange.send(self)
        }
    }
    
    /// Force an assessment of the current situation and update the context properties accordingly
    func refreshContext() {
        self.loggedIn = RawrKeychain().loggedIn
        if RawrKeychain().loggedIn {
            MisskeyKit.shared.changeInstance(instance: RawrKeychain().instanceHostname)
            MisskeyKit.shared.auth.setAPIKey(RawrKeychain().apiKey!)
            MisskeyKit.shared.users.i { userModel, _ in
                guard let userModel = userModel else {
                    return
                }
                self.currentUserId = userModel.id
                self.currentUser = userModel
            }
        }
    }
}
