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

struct BetterMainView: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var selectedTab: MainViewTab = .home
    
    var body: some View {
        NavigationStack {
            VStack {
                switch self.selectedTab {
                case .home:
                    BetterTimelineView()
                case .chats:
                    MessagesView()
                case .settings, .explore:
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
        }.background(context.themeBackground.ignoresSafeArea())
    }
}

#Preview {
    BetterMainView()
        .environmentObject(ViewContext())
}
