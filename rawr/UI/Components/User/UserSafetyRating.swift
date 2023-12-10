//
//  UserSafetyRating.swift
//  rawr.
//
//  Created by Nila on 10.12.2023.
//

import MisskeyKit
import SwiftKit
import SwiftUI

struct UserSafetyRating: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var user: UserModel
    @State private var failure: Bool = false
    
    var body: some View {
        Group {
            if self.user.id == self.context.currentUserId {
                Text("It's you")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.green).cornerRadius(.infinity))
            } else if self.failure {
                Text("Unavailable")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.red).cornerRadius(.infinity))
            } else if self.user.isFollowed == true && self.user.isFollowing == true {
                Text("Mutuals")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.green).cornerRadius(.infinity))
            } else if self.user.isFollowing == true {
                Text("Following")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.blue).cornerRadius(.infinity))
            } else if self.user.isFollowed == true {
                Text("Follower")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.purple).cornerRadius(.infinity))
            } else if self.user.isFollowed == nil || self.user.isFollowing == nil {
                ProgressView()
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.clear).fluentBackground().cornerRadius(.infinity))
            } else {
                Text("Strangers")
                    .padding(6)
                    .padding(.horizontal, 5)
                    .background(Rectangle().foregroundStyle(.gray).cornerRadius(.infinity))
            }
        }.onAppear(perform: self.onAppear)
    }
    
    private func onAppear() {
        // Partial User Check, we need to fetch the full user to get the info we want
        if self.user.isFollowed == nil || self.user.isFollowing == nil && self.user.id != self.context.currentUserId {
            MisskeyKit.shared.users.showUser(userId: self.user.id) { user, error in
                guard let user = user else {
                    self.failure = true
                    return
                }
                self.user = user
            }
        }
    }
}

#Preview {
    UserSafetyRating(user: .preview)
        .environmentObject(ViewContext())
}
