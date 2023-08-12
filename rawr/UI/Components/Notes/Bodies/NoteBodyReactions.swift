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
    @ObservedObject var note: NoteModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 60))
    ]

    var body: some View {
        WrappingHStack {
            ForEach((self.note.reactions ?? [:]).sorted(by: >), id: \.key) { key, value in
                HStack {
                    NetworkImage(url: URL(string: note.emojiUrlForReaction(name: key))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.primary.opacity(0.1))
                    }.clipped()
                        .frame(width: 25, height: 25)
                    Text(String(value))
                }.padding(5).background(note.isMyReaction(key) ? .blue.opacity(1) : .gray.opacity(0.1)).cornerRadius(5).padding(.trailing, 5)
                    .onTapGesture{
                        self.onReaction(key)
                    }
            }
        }
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
    NoteBodyReactions(note: .preview.renote!)
}
