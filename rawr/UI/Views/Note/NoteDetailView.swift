//
//  NoteDetailView.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteDetailView: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var note: NoteModel? = nil
    @State var replies: [NoteModel]? = nil
    
    let noteId: String
    
    var body: some View {
        VStack {
            if self.note == nil {
                self.loadingBody
            } else {
                self.noteBody
            }
        }
        .onAppear(perform: self.loadNote)
        .safeAreaInset(edge: .top, spacing: 0) {
            BetterAppHeader(isNavLink: true) {
                if self.note == nil {
                    AppHeaderSimpleBody {
                        HStack {
                            Text("Note")
                            Spacer()
                        }
                    }
                } else {
                    Note(note: self.note?.reply == nil ? self.note! : self.note!.reply!, components: [.header])
                }
            }
        }
    }
    
    var noteBody: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack {
                    if self.note!.reply != nil {
                        Note(note: self.note!, components: [.parentBody])
                        Note(note: self.note!, components: [.header, .body, .quotedNote, .reactions, .footer])
                            .padding(.bottom)
                    } else {
                        Note(note: self.note!, components: [.body, .quotedNote, .reactions, .footer])
                            .padding(.bottom)
                    }
                }
                .padding(.horizontal)
                .fluentBackground()
                .onAppear(perform: self.loadReplies)
                
                if self.replies != nil && self.replies!.count > 0 {
                    VStack {
                        Text("\(self.replies?.count ?? 0) Replies")
                            .padding(.vertical)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .background()
                    
                    self.repliesBody
                }
            }
        }
        .background(context.themeBackground.ignoresSafeArea())
    }
    
    var repliesBody: some View {
        ForEach(self.replies!, id: \.id) { reply in
            NavigationLink(value: NoteLink(id: reply.id!)) {
                Note(note: reply, components: [.header, .body, .reactions, .footer])
                    .padding(.horizontal)
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
    
    var loadingBody: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }.fluentBackground()
    }
    
    private func loadNote() {
        MisskeyKit.shared.notes.showNote(noteId: self.noteId) { note, error in
            guard let note = note else {
                self.context.applicationError = ApplicationError(title: "Fetching note failed", message: error.explain())
                print("NoteDetailView Error: API returned error while fetching note: \(error!)")
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
                print("NoteDetailView Error: API returned error while fetching note replies: \(error!)")
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
            NoteDetailView(noteId: "9m0f1ghyspol7j5k")
        }.safeAreaInset(edge: .bottom) {
            MainViewFooter(selectedTab: .constant(.home))
                .fluentBackground(.thin, fullscreen: false)
        }
    }.environmentObject(ViewContext())
}

