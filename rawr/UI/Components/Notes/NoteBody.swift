//
//  NoteBody.swift
//  rawr.
//
//  Created by Nila on 02.12.2023.
//

import MisskeyKit
import SwiftUI

struct NoteBody: View {
    
    @State var cwOverride: Bool = false
    
    @ObservedObject var note: NoteModel
    
    var body: some View {
        VStack {
            if note.text != nil && note.text != "" {
                NoteBodyText(note: note)
            }
            if note.hasFiles() {
                NoteBodyGallery(files: note.files ?? [])
            }
            if note.poll != nil {
                NoteBodyPoll(note: note)
            }
        }
        .overlay(alignment: .center) {
            if note.hasCW() && !cwOverride {
                VStack {
                    Text(note.cw!)
                        .foregroundStyle(.red)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .shadow(radius: 10)
                }
                .fluentBackground()
                .cornerRadius(5)
                .onTapGesture {
                    cwOverride = true
                }
            }
        }
    }
}

#Preview {
    NoteBody(note: .previewQuote)
}
