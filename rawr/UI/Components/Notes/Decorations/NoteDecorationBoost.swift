//
//  NoteDecorationBoost.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteDecorationBoost: View {
    @ObservedObject var note: NoteModel

    var body: some View {
        NavigationLink(value: TappedMention(username: "@\(self.note.user!.username!)@\(self.note.user!.host ?? RawrKeychain().instanceHostname)")) {
            HStack {
                Image(systemName: "arrow.2.squarepath")
                    .padding(.leading, 12)
                Group {
                    MFMBody(render: self.note.user.renderedDisplayName())
                        .environment(\.emojiRenderSize, CGSize(width: 15, height: 15))
                }
                .foregroundColor(.blue)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .padding(.leading, 12)
                Spacer()
                RelativeDate(date: self.note.createdAt!.toDate()!)
                    .foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 15))
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NoteDecorationBoost(note: .preview)
}
