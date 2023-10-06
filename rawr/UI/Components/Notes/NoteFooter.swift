//
//  NoteFooter.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit
import WrappingHStack


struct NoteFooter: View {

    @ObservedObject var note: NoteModel
    
    @EnvironmentObject var context: ViewContext
    @State var didRenote: Bool = false
    @State var emojiPickerShown = false
          
    var body: some View {
        HStack() {
            Button {} label: {
                HStack {
                    Image(systemName: "bubble.left").fontWeight(.light).padding(.bottom, -2)
                    Text(String(self.note.repliesCount ?? 0)).font(.system(size: 16, weight: .light))
                }
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
            Button {
                self.onReact()
            } label: {
                    Image(systemName: self.note.myReaction != nil ? "minus" : "star")
                        .foregroundColor(.primary)
                        .fontWeight(self.note.myReaction != nil ? .bold : .light)
            }
            Spacer()
            Button {
                emojiPickerShown = true
            } label: {
                HStack {
                    Image(systemName: "hands.sparkles")
                        .fontWeight(.light)
                    Text(String(self.note.reactionsCount())).font(.system(size: 16, weight: .light))
                }
            }
            .sheet(isPresented: $emojiPickerShown) {
                EmojiPicker { emoji in
                    self.onReact(":\(emoji):")
                    emojiPickerShown = false
                }.padding().presentationDetents([.fraction(0.45)])
            }
            Spacer()
            Button {} label: {
                Image(systemName: "quote.bubble")
                    .fontWeight(.light)
            }
        }
        .foregroundStyle(.primary)
    }

    private func onReact(_ r: String? = nil) {
        let reaction: String = r ?? context.currentInstance?.defaultReaction ?? ":star:"
        Task {
            do {
                if note.isMyReaction(reaction) ||
                    (r == nil && note.myReaction != nil) {
                    print("NoteFooter: Removing reaction from note")
                    try await note.unreact()
                } else {
                    print("NoteFooter: Setting reaction to post: \(reaction)")
                    try await note.react(reaction)
                }
            } catch let err {
                print(err.localizedDescription)
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
    }.environmentObject(ViewContext()).padding()
}
