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
    
    @State var emojiPickerShown = false
    
    /// Note States
    @State var didRenote: Bool = false
    @State var isFavourited: Bool? = nil
    @State var isMuted: Bool? = nil
    @State var isWatching: Bool? = nil
    
    @State var clips: [ClipModel]? = nil
    
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
                    Button(action: self.onBookmark) {
                        if self.isFavourited == nil {
                            Label("Checking Bookmarks...", systemImage: "bookmark")
                        } else if self.isFavourited! {
                            Label("Remove Bookmark", systemImage: "bookmark.slash")
                        } else {
                            Label("Bookmark", systemImage: "bookmark")
                        }
                    }
                    .disabled(self.isFavourited == nil)
                    Menu {
                        if self.clips == nil {
                            Button(action: {}, label: {
                                Text("Loading Clips...")
                            })
                            .disabled(true)
                        } else if self.clips!.count == 0 {
                            Button(action: {}, label: {
                                Text("No Clips")
                            })
                            .disabled(true)
                        } else {
                            ForEach(self.clips!) { clip in
                                Button(action: {
                                    self.onClip(clipId: clip.id!)
                                }, label: {
                                    Text(clip.name!)
                                })
                            }
                        }
                    } label: {
                        Label("Add to Clip", systemImage: "paperclip")
                    }
                    Button(action: self.onMute) {
                        if self.isMuted == nil {
                            Label("Checking Mutes...", systemImage: "speaker.slash")
                        } else if self.isMuted! {
                            Label("Unmute Thread", systemImage: "speaker")
                        } else {
                            Label("Mute Thread", systemImage: "speaker.slash")
                        }
                    }
                    .disabled(self.isMuted == nil)
                    Button(action: self.onTranslate) {
                        Label("Translate", systemImage: "character.bubble")
                    }
                    Button(action: self.onWatch) {
                        if self.isFavourited == nil {
                            Label("Checking Watches...", systemImage: "eye")
                        } else if self.isFavourited! {
                            Label("Unwatch", systemImage: "eye.slash")
                        } else {
                            Label("Watch", systemImage: "eye")
                        }
                    }
                    .disabled(self.isWatching == nil)
                    Divider()
                    Button(action: self.onCopyLink, label: {
                        Label("Copy Link", systemImage: "link")
                    })
                    Button(action: self.onCopyOriginalLink, label: {
                        Label("Copy Original Link", systemImage: "link.icloud")
                    })
                    ShareLink(item: self.note.absoluteLocalUrl())
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.light)
                        .frame(minWidth: NoteFooter.minButtonWidth,minHeight: NoteFooter.minButtonHeight)
                        .contentShape(Rectangle())
                }
                .onTapGesture(perform: self.onAppearMenu)
        }
        .foregroundStyle(.primary)
    }
    
    private func onAppearMenu() {
        MisskeyKit.shared.notes.getState(noteId: self.note.id!) { state, error in
            guard let state = state else {
                self.context.applicationError = ApplicationError(title: "Couldn't fetch note state", message: error.explain())
                return
            }
            self.isFavourited = state.isFavorited ?? false
            self.isWatching = state.isWatching ?? false
            self.isMuted = state.isMutedThread ?? false
        }
        MisskeyKit.shared.clips.list { clips, error in
            guard let clips = clips else {
                self.context.applicationError = ApplicationError(title: "Loading Clips failed", message: error.explain())
                print("NoteFooter Error: API returned an error while loading clips: \(error!)")
                return
            }
            self.clips = clips
        }
    }
    
    private func onBookmark() {
        guard let isFavourited = self.isFavourited else {
            return
        }

        if isFavourited {
            MisskeyKit.shared.notes.deleteFavorite(noteId: self.note.id!) { success, error in
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't delete bookmark", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't delete bookmark", message: "Contact your instance administrator for further information")
                } else {
                    self.isFavourited = false
                }
            }
        } else {
            MisskeyKit.shared.notes.createFavorite(noteId: self.note.id!) { success, error in
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't create bookmark", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't create bookmark", message: "Contact your instance administrator for further information")
                } else {
                    self.isFavourited = true
                }
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
    
    private func onClip(clipId: String) {
        MisskeyKit.shared.clips.addNote(clipId: clipId, noteId: self.note.id!) { success, error in
            if error != nil {
                self.context.applicationError = ApplicationError(title: "Couldn't add note to clip", message: error.explain())
            } else if !success {
                self.context.applicationError = ApplicationError(title: "Couldn't add note to clip", message: "Contact your instance administrator for further information")
            }
        }
    }
    
    private func onCopyLink() {
        UIPasteboard.general.url = self.note.absoluteLocalUrl()
    }
    
    private func onCopyOriginalLink() {
        UIPasteboard.general.url = self.note.absoluteUrl()
    }
    
    private func onMute() {
        guard let isMuted = self.isMuted else {
            return
        }
        
        if isMuted {
            MisskeyKit.shared.notes.unmute(noteId: self.note.id!) { success, error in
                print("Unmute response")
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't unmute note", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't unmute note", message: "Contact your instance administrator for further information")
                } else {
                    self.isMuted = false
                }
            }
        } else {
            MisskeyKit.shared.notes.mute(noteId: self.note.id!) { success, error in
                print("Mute response")
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't mute note", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't mute note", message: "Contact your instance administrator for further information")
                } else {
                    self.isMuted = true
                }
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
    
    private func onTranslate() {
        MisskeyKit.shared.notes.translate(noteId: self.note.id!) { translation, error in
            guard let translation = translation else {
                self.context.applicationError = ApplicationError(title: "Couldn't translate note", message: error.explain())
                return
            }
            DispatchQueue.main.sync {
                self.note.text = translation.text
                self.note.objectWillChange.send()
            }
        }
    }
    
    private func onWatch() {
        guard let isWatching = self.isWatching else {
            return
        }
        
        if isWatching {
            MisskeyKit.shared.notes.unWatchNote(noteId: self.note.id!) { success, error in
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't unwatch note", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't unwatch note", message: "Contact your instance administrator for further information")
                } else {
                    self.isWatching = false
                }
            }
        } else {
            MisskeyKit.shared.notes.watchNote(noteId: self.note.id!) { success, error in
                if error != nil {
                    self.context.applicationError = ApplicationError(title: "Couldn't watch note", message: error.explain())
                } else if !success {
                    self.context.applicationError = ApplicationError(title: "Couldn't watch note", message: "Contact your instance administrator for further information")
                } else {
                    self.isWatching = true
                }
            }
        }
    }
    
}

#Preview {
    NoteFooter(note: .previewRenote)
        .environmentObject(ViewContext())
        .padding()
        .fluentBackground(.thin, fullscreen: false)
}
