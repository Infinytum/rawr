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
                        VStack {
                            NoteBody(note: .init(text: item.text))
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .flippedUpsideDown()
                            if (self.shouldShowHeader(item: item, index: index)) {
                                NoteHeader(note: .init(createdAt: item.createdAt, user: item.user))
                                    .padding(.horizontal)
                                    .flippedUpsideDown()
                                if index != self.messageContext.items.count - 1 {
                                    if self.shouldShowTimeSeparator(item: item, index: index) {
                                        Divider()
                                            .padding(.top, 10)
                                        HStack {
                                            Image(systemName: "chevron.up")
                                            Text(self.messageContext.items[index + 1].createdAt!.toDate()!.relative(to: item.createdAt!.toDate()!).replacing("ago", with: "later"))
                                            Image(systemName: "chevron.down")
                                        }
                                        .flippedUpsideDown()
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                        .padding(.vertical, 2)
                                        Divider()
                                            .padding(.bottom)
                                    } else {
                                        Divider()
                                            .padding(.top, 10)
                                            .padding(.bottom)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            self.messageContext.requestMoreItemsIfNeeded(message: item)
                        }
                    }
                    
                    if self.messageContext.dataIsLoading{
                        ProgressView()
                    }
                }
                .padding(.vertical, 15)
                .fluentBackground()
            }
            .flippedUpsideDown()
        }
        .safeAreaInset(edge: .top, spacing: 0, content: {
            BetterAppHeader(isNavLink: true) {
                HStack {
                    VStack(alignment: .leading) {
                        MFMBody(render: self.history.remoteUser(currentUserId: self.context.currentUserId).renderedDisplayName())
                            .environment(\.emojiRenderSize, CGSize(width: 20, height: 20))
                            .frame(maxHeight: 20, alignment: .top)
                            .clipped()
                        Text("@" + (self.history.remoteUser(currentUserId: self.context.currentUserId).userName())).foregroundStyle(.gray)
                            .frame(maxHeight: 15)
                            .lineLimit(1)
                    }
                    Spacer()
                    UserSafetyRating(user: self.history.remoteUser(currentUserId: self.context.currentUserId))
                }
                .padding(.bottom, 2)
            }
        })
        .safeAreaInset(edge: .bottom, spacing: 0, content: {
            MessageBar(messageContext: self.messageContext)
        })
        .background(context.themeBackground)
        .onAppear {
            self.messageContext.requestInitialSetOfItems(remoteUserId: self.history.remoteUser(currentUserId: self.context.currentUserId).id)
        }
    }
    
    private func shouldShowTimeSeparator(item: MessageModel, index: Int) -> Bool {
        if index == self.messageContext.items.count - 1 {
            return false
        }
        
        let previousMessage = self.messageContext.items[index + 1]
        if previousMessage.recipientId == item.recipientId && Calendar.current.dateComponents([.hour], from: previousMessage.createdAt!.toDate()!, to: item.createdAt!.toDate()!).hour! >= 1 {
            return true
        }
        return false
    }
    
    private func shouldShowHeader(item: MessageModel, index: Int) -> Bool {
        if index == self.messageContext.items.count - 1 {
            return true
        }
        
        let previousMessage = self.messageContext.items[index + 1]
        if previousMessage.recipientId != item.recipientId {
            return true
        }
        
        if Calendar.current.dateComponents([.hour], from: previousMessage.createdAt!.toDate()!, to: item.createdAt!.toDate()!).hour! >= 1 {
            return true
        }
        return false
    }
}

#Preview {
    MessageView(history: .preview)
        .environmentObject(ViewContext())
}
