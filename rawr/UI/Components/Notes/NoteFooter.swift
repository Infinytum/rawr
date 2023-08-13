//
//  NoteFooter.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteFooter: View {
    @ObservedObject var note: NoteModel
    @State var didRenote: Bool = false
    
    var body: some View {
        HStack() {
            HStack {
                Image(systemName: "arrow.uturn.left")
                Text(String(self.note.repliesCount ?? 0))
            }
            Spacer()
            Menu {
                Button("Boost to everyone") {
                    self.onBoost(.public)
                }
                Button("Boost to home timeline") {
                    self.onBoost(.home)
                }
                Button("Boost to your followers") {
                    self.onBoost(.followers)
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.2.squarepath")
                        .foregroundColor(self.didRenote ? .blue : .primary)
                    Text(String(self.note.renoteCount ?? 0))
                }
            }.foregroundStyle(.primary)
            Spacer()
            HStack {
                Image(systemName: self.note.myReaction != nil ? "star.fill" : "star")
                Text(String(self.note.reactionsCount()))
            }
            Spacer()
            Image(systemName: "face.smiling")
            Spacer()
            Image(systemName: "quote.bubble")
        }
    }
    
    private func onBoost(_ visisbility: NoteModel.NoteVisibility) {
        MisskeyKit.shared.notes.renote(renoteId: self.note.id!, visibility: visisbility) { renote, error in
            guard let _ = renote else {
                print("Error while renoting/boosting")
                print(error ?? "No Error")
                return
            }
            withAnimation {
                self.note.renoteCount = (self.note.renoteCount ?? 0) + 1
                self.didRenote = true
            }
        }
    }
}

#Preview {
    NoteFooter(note: .preview.renote!)
}
