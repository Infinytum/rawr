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
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var didRenote: Bool = false
    @State var emojiPickerShown = false
    
    private static let minButtonHeight = CGFloat(25)
    private static let minButtonWidth = CGFloat(40)
          
    var body: some View {
        HStack() {
                HStack {
                    Image(systemName: "bubble.left").fontWeight(.light).padding(.bottom, -2)
                    Text(String(self.note.repliesCount ?? 0)).font(.system(size: 16, weight: .light))
                }
                .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                .contentShape(Rectangle())
                
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
                    }.foregroundStyle(.primary)
                }
                .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                .contentShape(Rectangle())
                
                Spacer()
                
                Button {
                    self.onReact()
                } label: {
                    Image(systemName: self.note.myReaction != nil ? "minus" : "star")
                        .foregroundColor(.primary)
                        .fontWeight(self.note.myReaction != nil ? .bold : .light)
                }
                .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                .contentShape(Rectangle())
                
                Spacer()
                
                Button {
                    emojiPickerShown = true
                    self.viewReloader.reloadView()
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
                .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                .contentShape(Rectangle())
                
                Spacer()
                
                Menu {
//                    Button(action: {}) {
//                        Label("Add to Bookmarks", systemImage: "bookmark")
//                    }
//                    Button(action: {}) {
//                        Label("Add to Clip", systemImage: "paperclip")
//                    }
//                    Button(action: {}) {
//                        Label("Mute Thread", systemImage: "speaker.slash")
//                    }
//                    Button(action: {}) {
//                        Label("Watch", systemImage: "eye")
//                    }
                    Divider()
                    Button(action: self.onCopyLink, label: {
                        Label("Copy Link", systemImage: "link")
                    })
                    Button(action: self.onCopyOriginalLink, label: {
                        Label("Copy Original Link", systemImage: "link.icloud")
                    })
                    ShareLink(item: self.note.absoluteLocalUrl())
//                    Button(action: {}) {
//                        Label("Open Original Page", systemImage: "point.3.connected.trianglepath.dotted")
//                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.light)
                        .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                        .contentShape(Rectangle())
                }
        }
        .foregroundStyle(.primary)
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
    
    private func onCopyLink() {
        UIPasteboard.general.url = self.note.absoluteLocalUrl()
    }
    
    private func onCopyOriginalLink() {
        UIPasteboard.general.url = self.note.absoluteUrl()
    }
    
}

#Preview {
    NoteFooter(note: .previewRenote)
        .environmentObject(ViewContext())
        .padding()
        .fluentBackground(.thin, fullscreen: false)
}
