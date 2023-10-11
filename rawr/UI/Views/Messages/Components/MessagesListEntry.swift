//
//  MessagesListEntry.swift
//  rawr.
//
//  Created by Nila on 06.10.2023.
//

import MisskeyKit
import SwiftUI

struct MessagesListEntry: View {
    
    @EnvironmentObject var context: ViewContext
    
    let history: MessageHistoryModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                RemoteImage(self.history.avatarUrl(currentUserId: context.currentUserId))
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(11)
                    .shadow(radius: 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.history.chatName(currentUserId: context.currentUserId) ?? "<No Name>")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .lineLimit(1, reservesSpace: true)
                        Spacer()
                        Text(self.history.createdAt?.toDate()?.relative() ?? "Unknown")
                            .font(.system(size: 14))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .frame(height: 17)
                    (self.getMessagePrefix() + self.getMessageText())
                        .font(.system(size: 18))
                        .lineLimit(1, reservesSpace: true)
                    
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
        return Text(self.history.text() ?? "<empty message>").font(.system(size: 18)).foregroundColor(.primary.opacity(0.7))
    }
}

#Preview {
    MessagesListEntry(history: .preview)
        .environmentObject(ViewContext())
}
