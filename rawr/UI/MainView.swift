//
//  MainView.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TimelineView()
              .tabItem {
                 Image(systemName: "house")
                 Text("Timeline")
               }
            Text("Notifications")
              .tabItem {
                 Image(systemName: "bell")
                 Text("Notifications")
               }
            ChatListView()
              .tabItem {
                 Image(systemName: "message")
                 Text("Chats")
               }
            Text("Settings")
              .tabItem {
                 Image(systemName: "gear")
                 Text("Settings")
               }
        }
    }
}

#Preview {
    MainView()
}
