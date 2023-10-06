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
    var renderedNote: MFMRender? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.note.isRenote() {
                NoteDecorationBoost(note: self.note)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
            }
            NoteHeader(note: self.actualNote())
                .padding(.horizontal)
            if self.actualNote().text != nil && self.actualNote().text != "" {
                NoteBodyText(note: self.actualNote(), renderedNote: self.renderedNote)
                    .padding(.horizontal)
                    .padding(.top, 5)
            }
            if self.actualNote().poll != nil {
                NoteBodyPoll(note: self.actualNote())
                    .padding(.horizontal)
            }
            if self.actualNote().hasFiles() {
                BetterNoteBodyGallery(files: self.actualNote().files ?? [])
                    .padding(.horizontal)
            }
            if self.actualNote().reactionsCount() > 0 {
                NoteBodyReactions(note: self.actualNote())
                    .padding(.horizontal)
                    .padding(.top, 5)
            }
            NoteFooter(note: self.actualNote())
                .padding(.horizontal)
                .padding(.top, 5)
        }
    }
    
    private func actualNote() -> NoteModel {
        return self.note.isRenote() ? self.note.renote! : self.note
    }
}
 
#Preview {
    VStack {
        Spacer()
        VStack {
            Note(note: .preview)
            .environmentObject(ViewContext())
            .padding(.vertical)
        }
        .background(.background)
        .cornerRadius(25)
        Spacer()
    }.padding().background(.primary)
}
