//
//  NoteBodyReactions.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import MisskeyKit
import NetworkImage
import WrappingHStack

struct NoteBodyReactions: View {
    @EnvironmentObject var context: ViewContext
    @ObservedObject var note: NoteModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 60))
    ]

    var body: some View {
        WrappingHStack(alignment: .leading) {
            ForEach((self.note.reactions ?? [:]).sorted(by: >), id: \.key) { key, value in
                HStack {
                    Emoji(name: key, emojis: note.emojis ?? [])
                        .environment(\.emojiRenderSize, CGSize(width: 20, height: 20))
                    Text(String(value))
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)
                .background(.clear)
                .foregroundStyle(.primary)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .cornerRadius(5)
                .padding(.trailing, 5)
                .highPriorityGesture(TapGesture().onEnded({ _ in
                    self.onReaction(key)
                }))
            }
        }.padding(.leading, 3)
    }
    
    private func getEmojiUrl(_ emoji: String) -> String? {
        let emojiNoteUrl = note.emojiUrlForReaction(name: emoji)
        if emojiNoteUrl != nil {
            return emojiNoteUrl
        }
        return self.context.currentInstance?.emojiUrlForReaction(name: emoji)
    }
    
    private func onReaction(_ reaction: String) {
        Task {
            do {
                if note.isMyReaction(reaction) {
                    try await note.unreact()
                } else {
                    try await note.react(reaction)
                }
            } catch {
                // TODO: Show error toasts on error
            }
        }
    }
}

#Preview {
    NoteBodyReactions(note: .previewRenote.renote!)
        .environmentObject(ViewContext())
        .padding()
        .fluentBackground(.thin, fullscreen: false)
}
