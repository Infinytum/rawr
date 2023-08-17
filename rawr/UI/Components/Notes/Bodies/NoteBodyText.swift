//
//  NoteBodyText.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteBodyText: View {
    let note: NoteModel
    var renderedNote: [IdentifiableView]? = nil
    
    var body: some View {
        VStack {
            ForEach(self.getRenderedNote()) { view in
                AnyView(view.view)
            }
        }
    }
    
    func getRenderedNote() -> [IdentifiableView] {
        return self.renderedNote ?? renderMFM(tokenize(self.note.text ?? ""), emojis: self.note.emojis ?? self.note.renote?.emojis ?? [])
    }
}

#Preview {
    NoteBodyText(note: .preview.renote!)
        .previewDisplayName("Short")
}
