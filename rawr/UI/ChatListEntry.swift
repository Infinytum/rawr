//
//  ChatListEntry.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import NetworkImage
import SwiftUI

struct ChatListEntry: View {
    
    @ObservedObject var context: ViewContext
    
    let history: MessageHistoryModel
    
    var body: some View {
        VStack {
            HStack {
                RemoteImage(self.history.avatarUrl(currentUserId: context.currentUserId))
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(11)
                    .shadow(radius: 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.history.chatName(currentUserId: context.currentUserId) ?? "<No Name>").fontWeight(.bold)
                            .lineLimit(1, reservesSpace: true)
                        Spacer()
                        Text(self.history.createdAt?.toDate()?.relative() ?? "Unknown")
                            .font(.system(size: 14))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    (self.getMessagePrefix() + self.getMessageText()).lineLimit(2, reservesSpace: true)

                }.padding(.leading, 5)
            }
        }
    }
    
    private func getMessagePrefix() -> Text {
        if self.history.isOwnMessage(currentUserId: context.currentUserId) {
            return Text("You: ").foregroundColor(.gray)
        }
        return Text("")
    }
    
    private func getMessageText() -> Text {
        return Text(self.history.text() ?? "<empty message>").font(.system(size: 16)).foregroundColor(.primary.opacity(0.7))
    }
}

#Preview {
    ChatListEntry(context: ViewContext(), history: .preview)
}
