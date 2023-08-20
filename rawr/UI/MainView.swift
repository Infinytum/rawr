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
            NotificationView()
              .tabItem {
                 Image(systemName: "bell")
                 Text("Notifications")
               }
            ChatListView()
              .tabItem {
                 Image(systemName: "message")
                 Text("Chats")
               }
        }
    }
}

#Preview {
    MainView().environmentObject(ViewContext())
}
