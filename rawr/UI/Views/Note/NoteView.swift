//
//  NoteView.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteView: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var note: NoteModel? = nil
    @State var replies: [NoteModel]? = nil
    
    let noteId: String
    
    var body: some View {
        VStack {
            if self.note == nil {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }.fluentBackground()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        Note(note: self.note!)
                            .padding(.vertical)
                            .fluentBackground()
                            .onAppear(perform: self.loadReplies)
                        if self.replies != nil && self.replies!.count > 0 {
                            VStack {
                                Text("\(self.replies?.count ?? 0) Replies")
                                    .padding(.vertical).foregroundColor(.primary.opacity(0.7))
                            }.background()
                            
                            ForEach(self.replies!, id: \.id) { reply in
                                NavigationLink(destination: NoteView(noteId: reply.id!).navigationBarBackButtonHidden(true)) {
                                    Note(note: reply)
                                }
                                .buttonStyle(PlainButtonStyle())
                                    .padding(.vertical)
                                    .overlay(alignment: .bottom) {
                                        Rectangle()
                                            .foregroundStyle(.gray.opacity(0.3))
                                            .frame(height: 0.5)
                                    }
                                    .fluentBackground()
                            }
                        }
                    }
                }
                .background(context.themeBackground.ignoresSafeArea())
            }
        }
        .onAppear(perform: self.loadNote)
        .safeAreaInset(edge: .top, spacing: 0) {
            AppHeader(isNavLink: true) {
                Text("Note")
            }
        }
    }
    
    private func loadNote() {
        MisskeyKit.shared.notes.showNote(noteId: self.noteId) { note, error in
            guard let note = note else {
                self.context.applicationError = ApplicationError(title: "Fetching note failed", message: error.explain())
                print("NoteView Error: API returned error while fetching note: \(error!)")
                return
            }
            self.note = note
        }
    }
    
    private func loadReplies() {
        guard let note = self.note else { return }
        MisskeyKit.shared.notes.getChildren(noteId: note.isRenote() ? note.renote!.id! : self.noteId ) { replies, error in
            guard let replies = replies else {
                self.context.applicationError = ApplicationError(title: "Fetching note replies failed", message: error.explain())
                print("NoteView Error: API returned error while fetching note replies: \(error!)")
                return
            }
            self.replies = replies.filter({ model in
                return model.replyId == self.noteId || model.replyId == self.note?.renoteId
            })
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            NoteView(noteId: "9iklw7fsr7cofp5k").environmentObject(ViewContext())
        }.safeAreaInset(edge: .bottom) {
            MainViewFooter(selectedTab: .constant(.home))
                .fluentBackground(.thin, fullscreen: false)
        }
    }
}

