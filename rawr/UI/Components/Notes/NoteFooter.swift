//
//  NoteFooter.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit
import WrappingHStack

struct emoji {
    var name: String
    var image: RemoteImage?
    var emojiChar: Text?
}

struct NoteFooter: View {
    @EnvironmentObject var context: ViewContext

    @ObservedObject var note: NoteModel
    @State var didRenote: Bool = false
    @State var emojiPickerShown = false
    @State private var emojiList: [String: [emoji]] = [:]
    @State private var favouriteEmojis: [emoji] = []
    
    private var emojiCategoriesArray: [String]{
        var initial = Array(emojiList.keys).sorted(by:<)
        if initial.count == 0 {
            return []
        }
        initial.removeLast()
        initial.insert("uncategorized", at: 0)
        return initial
    }
    
    var body: some View {
        HStack() {
            Button {} label: {
                HStack {
                    Image(systemName: "text.bubble").fontWeight(.light).padding(.bottom, -2)
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
                List {
                    ForEach(emojiCategoriesArray, id: \.self) {category in
                        EmojiSection(emojiContent: emojiList[category]!, categoryName: category.replacingOccurrences(of: "_", with: " ")) {name in
                            if emojiList[category]?.first(where: {$0.name == name})?.name == nil {
                                print(category)
                            }
                            
                            onReact(emojiList[category]!.first{$0.name == name}!.name)
                        }
                    }
                }
                .onAppear {
                    fillEmojiList()
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowSpacing(.zero)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "quote.bubble")
                    .fontWeight(.light)
            }
        }
        .foregroundStyle(.primary)
    }
    
    private func fillEmojiList() {
        emojiList = [:]
        if context != nil {
            for emoji in context.currentInstance?.emojis ?? [] {
                let category = emoji.category ?? "uncategorized"
                var tempArray = emojiList[category] ?? []
                tempArray.append(
                    .init(name: ":\(emoji.name!):", image: RemoteImage(emoji.url))
                )
                emojiList[category] = tempArray
            }
        }
        
        MisskeyKit.shared.emojis.getDefault {emojis in
            guard let emojis = emojis else {
                return
            }
            emojis.forEach {emoji in
                let category = emoji.category
                var tempArray = emojiList[category?.rawValue ?? "uncategorized"] ?? []
                
                guard emoji.char != nil else {
                    return
                }
                
                tempArray.append(
                    .init(name: ":\(emoji.name!):", emojiChar: Text(emoji.char!))
                )
                emojiList[category?.rawValue ?? "uncategorized"] = tempArray
            }
        }
    }
    
    private func onReact(_ r: String? = nil) {
        let reaction: String = r ?? context.currentInstance?.defaultReaction ?? ":star:"
        Task {
            do {
                if note.isMyReaction(reaction) ||
                    (r == nil && note.myReaction != nil) {
                    print("unreacting.")
                    try await note.unreact()
                } else {
                    print("is not my reaction, reacting with \(reaction)")
                    try await note.react(reaction)
                }
                emojiPickerShown = false
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
    }.padding()
}
