//
//  MainView.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var context: ViewContext
    
    var body: some View {
        TabView {
            TimelineView(context: self.context)
              .tabItem {
                 Image(systemName: "house")
                 Text("Timeline")
               }
            Text("Notifications")
              .tabItem {
                 Image(systemName: "bell")
                 Text("Notifications")
               }
            ChatListView(context: self.context)
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
    MainView(context: ViewContext())
}
