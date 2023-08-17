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
    var renderedNote: [IdentifiableView]? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.note.isRenote() {
                NoteDecorationBoost(note: self.note).padding(.bottom, 5)
            }
            NoteHeader(note: self.actualNote())
            NoteBodyText(note: self.actualNote(), renderedNote: self.renderedNote)
            if self.actualNote().hasFiles() {
                NoteBodyGallery(files: self.actualNote().files!)
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
        Note(note: .preview).background(.white)
        Divider()
        Note(note: .preview).background(.white)
        Divider()
        Note(note: .preview).background(.white)
        Divider()
    }.padding()
}
