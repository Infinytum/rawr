//
//  MessageView.swift
//  rawr.
//
//  Created by Nila on 06.10.2023.
//

import MisskeyKit
import SwiftUI

fileprivate struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
     content
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

fileprivate extension View {
    func flippedUpsideDown() -> some View {
      self.modifier(FlippedUpsideDown())
    }
}

struct MessageView: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var messageContext = MessageContext()
    
    @State var history: MessageHistoryModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0){
                    ForEach(Array(self.messageContext.items.enumerated()), id: \.1.id) { (index, item) in
                        ChatMessage(chatMessage: item, remote: (item.recipientId ?? "") == self.context.currentUserId)
                            .flippedUpsideDown()
                            .onAppear { self.messageContext.requestMoreItemsIfNeeded(message: item) }
                            .padding(
                                .top,
                                (index == 0 || self.messageContext.items[index-1].recipientId?.elementsEqual( item.recipientId ?? "") ?? false) ? 0 : 15)
                    }
                    
                    if self.messageContext.dataIsLoading{
                        ProgressView()
                    }
                }
                .padding(.horizontal)
            }
            .flippedUpsideDown()
            MessageBar(messageContext: self.messageContext)
        }
        .safeAreaInset(edge: .top, spacing: 0, content: {
            BetterAppHeader(isNavLink: true) {
                RemoteImage(self.remoteUser().avatarUrl)
                    .frame(width: 50, height: 50)
                    .cornerRadius(11)
                HStack {
                    VStack(alignment: .leading) {
                        MFMBody(render: self.remoteUser().renderedDisplayName())
                            .environment(\.emojiRenderSize, CGSize(width: 20, height: 20))
                            .frame(maxHeight: 20, alignment: .top)
                            .clipped()
                        Text("@" + (self.remoteUser().userName())).foregroundStyle(.gray)
                            .frame(maxHeight: 15)
                            .lineLimit(1)
                    }
                    Spacer()
                    UserSafetyRating(user: self.remoteUser())
                }
                .padding(.leading, 2)
                .padding(.bottom, 2)
            }
        })
        .background(context.themeBackground)
        .onAppear {
            self.messageContext.requestInitialSetOfItems(remoteUserId: self.history.remoteUserId(currentUserId: context.currentUserId) ?? "")
        }
    }
    
    private func remoteUser() -> UserModel {
        if self.history.isOwnMessage(currentUserId: self.context.currentUserId) {
            return self.history.recipient!
        }
        return self.history.user!
    }
}

#Preview {
    MessageView(history: .preview)
        .environmentObject(ViewContext())
}
