//
//  NewNoteButton.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NewNoteButton: View {
    
    @State var showNoteSheet: Bool = false
    
    var body: some View {
        Button {
            self.showNoteSheet = true
        } label: {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 20))
        }.sheet(isPresented: self.$showNoteSheet, content: {
            NoteEditorView()
        })
    }
}

#Preview {
    NewNoteButton()
}
