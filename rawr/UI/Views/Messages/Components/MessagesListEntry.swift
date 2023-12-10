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
            NoteHeader(note: .init(createdAt: self.history.createdAt, user: self.remoteUser()))
            NoteBody(note: .init(text: self.text()))
                .padding(.vertical, 5)
                .overlay(alignment: .trailing) {
                    if self.history.isRead == false && !self.history.isOwnMessage(currentUserId: self.context.currentUserId) {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                    }
                }
                .foregroundColor(
                    self.history.isOwnMessage(currentUserId: self.context.currentUserId) ?
                        .primary.opacity(0.7) : .primary
                )
        }
    }
    
    private func remoteUser() -> UserModel? {
        if self.history.recipientId == self.context.currentUserId {
            return self.history.user
        }
        return self.history.recipient
    }
    
    private func text() -> String? {
        if self.history.isOwnMessage(currentUserId: self.context.currentUserId) {
            return "**You**: " + (self.history.text() ?? "")
        }
        return self.history.text()
    }
}

#Preview {
    NavigationView {
        LazyVStack(spacing: 0) {
            MessagesListEntry(history: .preview)
                .environmentObject(ViewContext())
            Divider().padding(.vertical, 10)
            MessagesListEntry(history: .preview)
                .environmentObject(ViewContext())
            Divider().padding(.vertical, 10)
            MessagesListEntry(history: .preview)
                .environmentObject(ViewContext())
            Divider().padding(.vertical, 10)
            MessagesListEntry(history: .preview)
                .environmentObject(ViewContext())
        }
        .padding(.horizontal)
        .fluentBackground()
    }
}
