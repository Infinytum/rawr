//
//  NoteFooter.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteFooter: View {
    @EnvironmentObject var context: ViewContext

    @ObservedObject var note: NoteModel
    @State var didRenote: Bool = false
    
    var body: some View {
        HStack() {
            HStack {
                Image(systemName: "text.bubble").fontWeight(.light).padding(.bottom, -2)
                Text(String(self.note.repliesCount ?? 0)).font(.system(size: 16, weight: .light))
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
                        .foregroundColor(self.didRenote ? .blue : .primary).fontWeight(.light)
                    Text(String(self.note.renoteCount ?? 0)).font(.system(size: 16, weight: .light))
                }
            }.foregroundStyle(.primary)
            Spacer()
            HStack {
                Image(systemName: "star").foregroundColor(self.note.myReaction != nil ? .yellow : .primary).fontWeight(self.note.myReaction != nil ? .bold : .light)
                Text(String(self.note.reactionsCount())).font(.system(size: 16, weight: .light))
            }.onTapGesture {
                self.onReact()
            }
            Spacer()
            Image(systemName: "hands.and.sparkles")
                .fontWeight(.light)
            Spacer()
            Image(systemName: "quote.bubble")
                .fontWeight(.light)
        }
    }
    
    private func onReact() {
        let reaction = self.context.currentInstance?.defaultReaction ?? ":star:"
        Task {
            do {
                if note.isMyReaction(reaction) {
                    try await note.unreact()
                } else {
                    try await note.react(reaction)
                }
            } catch {
                // TODO: Show error toasts on error
            }
        }
    }
    
    private func onBoost(_ visisbility: NoteModel.NoteVisibility) {
        MisskeyKit.shared.notes.renote(renoteId: self.note.id!, visibility: visisbility) { renote, error in
            guard let _ = renote else {
                self.context.applicationError = ApplicationError(title: "Renote failed", message: error.explain())
                print("NoteFooter Error: API returned an error while creating renote: \(error!)")
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
    ScrollView {
        Note(note: .preview)
        Divider()
        Note(note: .preview)
        Divider()
        Note(note: .preview)
    }.padding()
}
