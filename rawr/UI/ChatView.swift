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
    func flippedUpsideDown() -> some View{
      self.modifier(FlippedUpsideDown())
    }
 }

struct ChatView: View {
    
    @ObservedObject var context: ViewContext
    @ObservedObject var chatContext: ChatContext
    
    let history: MessageHistoryModel
    
    init(context: ViewContext, history: MessageHistoryModel) {
        self.context = context
        self.history = history
        self.chatContext = ChatContext(remoteUserId: self.history.remoteUserId(currentUserId: context.currentUserId) ?? "")
        self.chatContext.requestInitialSetOfItems()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if self.chatContext.errorReason == nil {
                    List {
                        ForEach(Array(self.chatContext.items.enumerated()), id: \.1.id) { (index, item) in
                                ChatMessage(chatMessage: item, remote: (item.recipientId ?? "") == self.context.currentUserId)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets())
                                    .flippedUpsideDown()
                                    .onAppear { self.chatContext.requestMoreItemsIfNeeded(message: item) }
                                    .padding(
                                        .top,
                                        (index == 0 || self.chatContext.items[index-1].recipientId?.elementsEqual( item.recipientId ?? "") ?? false) ? 0 : 15)
                                        }
                        if self.chatContext.dataIsLoading || true {
                            ProgressView()
                        }
                    }.padding(.horizontal)
                    .listStyle(.plain)
                    .flippedUpsideDown()
                } else {
                    VStack {
                        Spacer()
                        Text(self.chatContext.errorReason!)
                        Spacer()
                    }
                }
                ChatBar(chatContext: self.chatContext)
            }.padding(.top, 55)
            VStack {
                ChatHeader(context: self.context, history: self.history)
            }
        }.presentationDragIndicator(.visible)
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true), content: {
        ChatView(context: ViewContext(), history: .preview)
    })
}
