//
//  NoteView.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteView: View {
    var note: NoteModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.note.isRenote() {
                NoteDecorationBoost(note: self.note).padding(.bottom, 10)
            }
            NoteHeader(note: self.note.isRenote() ? self.note.renote! : self.note)
            NoteBodyText(text: (self.note.isRenote() ? self.note.renote?.text : self.note.text) ?? "")
            if self.note.hasFiles() {
                NoteBodyGallery(files: self.note.isRenote() ? self.note.renote!.files! : self.note.files!)
            }
            NoteBodyReactions(note: self.note.isRenote() ? self.note.renote! : self.note).padding(.top, 5)
            NoteFooter(note: self.note.isRenote() ? self.note.renote! : self.note).padding(.horizontal, 5).padding(.top, 5)
        }
    }
}
 
#Preview {
    ScrollView {
        VStack {
            NoteView(note: .preview)
        }.padding()
    }
}
