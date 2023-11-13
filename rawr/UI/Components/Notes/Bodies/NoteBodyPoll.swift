//
//  NoteBodyPoll.swift
//  rawr.
//
//  Created by Dråfølin on 8/22/23.
//

import SwiftUI
import MisskeyKit

struct NoteBodyPoll: View {
    
    @EnvironmentObject var context: ViewContext
    
    @ObservedObject var note: NoteModel
    @ObservedObject private var viewReloader: ViewReloader = .init()
        
    var body: some View {
        VStack {
            VStack {
                ForEach(Array(note.poll!.choices!.enumerated()), id: \.1?.text) {index, choice in
                    PollSelection(choice: choice!, note: note) {
                        let voteCount = (self.note.poll!.votedForChoices ?? []).count
                        if voteCount == 0 || (self.note.poll!.multiple ?? false) {
                            Task {
                                do {
                                    try await note.vote(index)
                                    self.viewReloader.reloadView()
                                } catch {
                                    self.context.applicationError = ApplicationError(title: "Vote failed", message: String(describing: error))
                                }
                            }
                        }
                    }
                }
            }
            HStack {
                Text("\(note.poll!.totalVotes) votes")
                Text("-")
                if note.poll!.expiresAt != nil {
                    Text("Closed \(note.poll!.expiresAt!.toDate()!.relative())")
                } else {
                    Text("Final results")
                }
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 14))
        }
    }
}

#Preview {
    @State var note: NoteModel = .preview
    note.poll = .preview
    note.renote!.poll = .preview
    return Note(note: note).environmentObject(ViewContext())
}
