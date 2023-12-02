//
//  BetterMainView.swift
//  rawr.
//
//  Created by Nila on 17.09.2023.
//

import MisskeyKit
import NetworkImage
import SwiftKit
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var selectedTab: MainViewTab = .home
    
    var body: some View {
        NavigationStack {
            VStack {
                switch self.selectedTab {
                case .home:
                    TimelineView()
                case .chats:
                    MessagesView()
                case .notifications:
                    NotificationView()
                case .explore:
                    Spacer()
                    Image(.gremlin)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("✨ Coming Soon ✨")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                    Spacer()
                }
            }.safeAreaInset(edge: .bottom, spacing: 0, content: {
                MainViewFooter(selectedTab: self.$selectedTab)
                    .fluentBackground(.thin, fullscreen: false)
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
            .navigationDestination(for: TappedHashtag.self, destination: { hashtag in
                HashtagTimelineView(hashtag: hashtag.hashtag)
                    .navigationBarBackButtonHidden(true)
            })
            .navigationDestination(for: TappedMention.self, destination: { mention in
                UserView(userName: mention.username)
                    .navigationBarBackButtonHidden(true)
            })
            .navigationDestination(for: NoteLink.self, destination: { note in
                NoteDetailView(noteId: note.id)
                    .navigationBarBackButtonHidden(true)
            })
        }
        .background(context.themeBackground.ignoresSafeArea())
    }
}

#Preview {
    MainView()
        .environmentObject(ViewContext())
}
