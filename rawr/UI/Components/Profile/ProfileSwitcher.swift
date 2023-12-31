//
//  ProfileSwitcher.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import NetworkImage

struct ProfileSwitcher: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State private var displayOwnProfile = false
    
    var body: some View {
        Menu {
//            Section("Available Accounts") {
//                Button("First") {  }
//                Button("Second") {  }
//            }
//            Button {
//            } label: {
//                Label("Add Account", systemImage: "person.badge.plus")
//            }
            Button {
                displayOwnProfile = true
            } label: {
                Label("Your profile", systemImage: "person")
            }
            
            Button(role: .destructive) {
                RawrKeychain().apiKey = nil
                self.context.refreshContext()
            } label: {
                Label("Logout", systemImage: "trash")
            }
        } label: {
            RemoteImage(self.context.currentUser?.avatarUrl).cornerRadius(11)
        }
        .sheet(isPresented: $displayOwnProfile) {
            UserView(userName: "@\(context.currentUser!.username!)")
        }
        
    }
}

#Preview {
    VStack {
        Spacer()
        ProfileSwitcher()
            .frame(width: 75, height: 75)
            .padding(.bottom, 20)
        Text("Profile Switcher")
            .font(.system(size: 25, weight: .thin))
        Text("Switch profile by tapping the current profile")
            .font(.system(size: 18, weight: .thin))
        Spacer()
    }.padding()
}
