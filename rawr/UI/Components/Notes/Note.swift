//
//  NoteView.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct Note: View {
    @ObservedObject var note: NoteModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.note.isRenote() {
                NoteDecorationBoost(note: self.note)
            }
            NoteHeader(note: self.actualNote())
            NoteBodyText(text: self.actualNote().text ?? "")
            if self.actualNote().hasFiles() {
                NoteBodyGallery(files: self.actualNote().files!).padding(.bottom, 5)
            }
            if self.actualNote().reactionsCount() > 0 {
                NoteBodyReactions(note: self.actualNote())
            }
            Divider()
            NoteFooter(note: self.actualNote()).padding(.horizontal, 5).padding(.top, 5)
        }.padding(.vertical, 5)
    }
    
    private func actualNote() -> NoteModel {
        return self.note.isRenote() ? self.note.renote! : self.note
    }
}
 
#Preview {
    ScrollView {
        Text("Bounding Box Check")
        VStack {
            Note(note: .preview).background(.white)
        }.padding()
    }.background(.gray)
}
