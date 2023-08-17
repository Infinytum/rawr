//
//  ChatView.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import SwiftUI

internal struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
     content
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
 }

internal extension View{
    func flippedUpsideDown() -> some View {
      self.modifier(FlippedUpsideDown())
    }
 }

struct ChatView: View {
    @EnvironmentObject var context: ViewContext

    @ObservedObject var chatContext = ChatContext()
    
    let history: MessageHistoryModel
    
    var body: some View {
        VStack {
            ChatHeader(history: self.history)
            if self.chatContext.errorReason == nil {
                ScrollView {
                    LazyVStack(spacing: 0){
                        ForEach(Array(self.chatContext.items.enumerated()), id: \.1.id) { (index, item) in
                            ChatMessage(chatMessage: item, remote: (item.recipientId ?? "") == self.context.currentUserId)
                                .flippedUpsideDown()
                                .onAppear { self.chatContext.requestMoreItemsIfNeeded(message: item) }
                                .padding(
                                    .top,
                                    (index == 0 || self.chatContext.items[index-1].recipientId?.elementsEqual( item.recipientId ?? "") ?? false) ? 0 : 15)
                        }
                        
                        if self.chatContext.dataIsLoading{
                            ProgressView()
                        }
                    }
                        .padding(.horizontal)
                }
                    .flippedUpsideDown()
            } else {
                VStack {
                    Spacer()
                    Text(self.chatContext.errorReason!)
                    Spacer()
                }
            }
            ChatBar(chatContext: self.chatContext)
            
        }
            .presentationDragIndicator(.visible)
            .onAppear {
                self.chatContext.requestInitialSetOfItems(remoteUserId: self.history.remoteUserId(currentUserId: context.currentUserId) ?? "")
                
            }
    }
}

#Preview {
    VStack(content:{})
        .sheet(isPresented: .constant(true)) {
        ChatView(history: .preview)
            .environmentObject(ViewContext())
    }
}
