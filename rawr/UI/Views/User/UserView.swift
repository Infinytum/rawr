//
//  UserView.swift
//  rawr.
//
//  Created by Dråfølin on 8/20/23.
//

import SwiftUI
import MisskeyKit

struct UserView: View {
    @EnvironmentObject var context: ViewContext
    
    let userName: String
    
    @State private var user: UserModel?
    
    var body: some View {
        VStack {
            if user != nil {
                User(user: self.user!)
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }.onAppear(perform: self.onAppear)
    }
    
    private func onAppear() {
        var userComponents = self.userName.components(separatedBy: "@")
        if (userComponents.first ?? "") == "" {
            userComponents.removeFirst()
        }
        
        guard let username = userComponents.first else {
            self.context.applicationError = ApplicationError(title: "Unable to display User", message: "Unable to determine username to display")
            print("UserView: Unable to determine username to display")
            return
        }
        
        let instance = userComponents.count > 1 ? userComponents[1] : ""
        MisskeyKit.shared.users.showUser(username: username, host: instance) { user, error in
            guard let user = user else {
                self.context.applicationError = ApplicationError(title: "Fetching user failed", message: error.explain())
                print("UserView: Error while fetching user from API: \(error!)")
                return
            }
            self.user = user
        }
    }
}

#Preview {
    UserView(userName: "@nila")
        .environmentObject(ViewContext())
}
