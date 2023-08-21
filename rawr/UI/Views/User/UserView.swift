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
    
    @State var userName: String
    @State private var user: UserModel?
    @State private var error: MisskeyKitError?
    @State private var isErrored: Bool = false
    @State private var selectedScope: UserTimelineContext.timelineScope = .notes

    var body: some View {
        VStack {
            if user != nil {
                UserTimelineHeader(user: user, selectedScope: $selectedScope)
                Timeline(timelineContext: UserTimelineContext(user!.id, selectedScope))
            } else if !isErrored {
                Text("Loading...")
            } else {
                Image(systemName: "triangle.exclamationmark")
            }
        }
        .alert(error?.localizedDescription ?? "no error", isPresented: $isErrored) {
        }
        .onAppear{
            // MARK: User initialisation
            var userComponents = userName.components(separatedBy: "@")
            userComponents.removeFirst()
            if userComponents.count == 1 {
                let username = userComponents[0]
                MisskeyKit.shared.users.showUser(username: username) {user,err in
                    guard err == nil else {
                        error = err
                        return
                    }
                    self.user = user
                }
            } else if userComponents.count == 2 {
                MisskeyKit.shared.users.showUser(username:  userComponents[0], host: userComponents[1]) {user,err in
                    guard err == nil else {
                        error = err
                        return
                    }
                    
                    self.user = user
                }
                
            } else {
                print("Invalid username \(userName)")
                return
            }
        }
        
    }
}

#Preview {
    UserView(userName: "dråfølin")
}
