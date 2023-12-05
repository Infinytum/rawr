//
//  NoteBodyText.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteBodyText: View {
    
    @EnvironmentObject var context: ViewContext
    
    @ObservedObject var note: NoteModel
    @State var renderedNote: MFMRender? = nil
    
    var body: some View {
        MFMBody(render: self.renderedNote ?? self.renderNote())
    }
    
    func renderNote() -> MFMRender {
        return mfmRender(Tokenizer.note.tokenize(self.note.text ?? ""), emojis: self.note.emojis ?? self.note.renote?.emojis ?? [])
    }
}

#Preview {
    NoteBodyText(note: .preview.renote!)
        .previewDisplayName("Short")
        .environmentObject(ViewContext())
}

