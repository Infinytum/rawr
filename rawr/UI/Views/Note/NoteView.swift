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
    
    @State var subNoteId: String? = nil
    @State var subNoteShown: Bool = false
    
    let noteId: String
    
    var body: some View {
        if self.note == nil {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear(perform: self.loadNote)
        } else {
            ScrollView {
                Note(note: self.note!)
                    .onAppear(perform: self.loadReplies)
                if self.replies == nil {
                    ProgressView()
                } else {
                    Divider()
                    Text("\(self.replies?.count ?? 0) Replies").padding(.top, 1).foregroundColor(.primary.opacity(0.7))
                    Divider()
                    ForEach(self.replies!, id: \.id) { reply in
                        Note(note: reply)
                            .onTapGesture {
                                self.subNoteId = reply.id
                                self.viewReloader.reloadView()
                                self.subNoteShown = true
                            }
                        Divider()
                    }
                    Spacer()
                }
            }.padding().sheet(isPresented: self.$subNoteShown) {
                NoteView(noteId: self.subNoteId!)
            }
        }
    }
    
    private func loadNote() {
        MisskeyKit.shared.notes.showNote(noteId: self.noteId) { note, error in
            guard let note = note else {
                print("Error fetching note")
                print(error ?? "No Error")
                return
            }
            self.note = note
        }
    }
    
    private func loadReplies() {
        guard let note = self.note else { return }
        MisskeyKit.shared.notes.getChildren(noteId: note.isRenote() ? note.renote!.id! : self.noteId ) { replies, error in
            guard let replies = replies else {
                print("Error fetching note replies")
                print(error ?? "No Error")
                return
            }
            self.replies = replies
        }
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true)) {
        NoteView(noteId: "9idb4z14g6fn6185").environmentObject(ViewContext())
    }
}

