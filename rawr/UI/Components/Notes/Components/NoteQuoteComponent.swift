//
//  NoteQuoteComponent.swift
//  rawr.
//
//  Created by Nila on 03.12.2023.
//

import MisskeyKit
import SwiftUI

struct NoteQuoteComponent: View {
    
    let note: NoteModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NoteHeader(note: self.note)
            NavigationLink(value: NoteLink(id: self.note.id!)) {
                NoteBody(note: self.note)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.all, 12)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .clipped()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
        .padding(.top, 5)
    }
}

#Preview {
    NoteQuoteComponent(note: .previewRenote.renote!)
}
