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
                NoteDecorationBoost(note: self.note).padding(.vertical, 10)
            }
            NoteHeader(note: self.note.isRenote() ? self.note.renote! : self.note)
            NoteBodyText(text: (self.note.isRenote() ? self.note.renote?.text : self.note.text) ?? "")
            if self.note.hasFiles() {
                NoteBodyGallery(files: self.note.isRenote() ? self.note.renote!.files! : self.note.files!)
            }
            NoteBodyReactions(note: self.note.isRenote() ? self.note.renote! : self.note).padding(.top, 5)
            NoteFooter(note: self.note.isRenote() ? self.note.renote! : self.note).padding(.all, 5)
        }
    }
}
 
#Preview {
    ScrollView {
        Text("Bounding Box Check")
        VStack {
            NoteView(note: .preview)
        }.background(.gray).padding()
    }
}
