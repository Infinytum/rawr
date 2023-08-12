//
//  NoteFooter.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteFooter: View {
    let note: NoteModel
    
    var body: some View {
        HStack() {
            HStack {
                Image(systemName: "arrow.uturn.left")
                Text(String(self.note.repliesCount ?? 0))
            }
            Spacer()
            HStack {
                Image(systemName: "arrow.2.squarepath")
                Text(String(self.note.renoteCount ?? 0))
            }
            Spacer()
            HStack {
                Image(systemName: "star")
                Text(String(self.note.reactionsCount()))
            }
            Spacer()
            Image(systemName: "face.smiling")
            Spacer()
            Image(systemName: "quote.bubble")
        }
    }
}

#Preview {
    NoteFooter(note: .preview.renote!)
}
