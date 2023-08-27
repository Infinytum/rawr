//
//  NoteBodyPoll.swift
//  rawr.
//
//  Created by Dråfølin on 8/22/23.
//

import SwiftUI
import MisskeyKit

struct NoteBodyPoll: View {
    @ObservedObject var note: NoteModel
    @ObservedObject private var viewReloader: ViewReloader = .init()
        
    var body: some View {
        VStack {
            VStack {
                ForEach(Array(note.poll!.choices!.enumerated()), id: \.1?.text) {index, choice in
                    PollSelection(choice: choice!, note: note) {
                        Task {
                            do {
                                try await note.vote(index)
                            } catch {
                                
                            }
                        }
                    }
                }
            }
            HStack {
                Text("\(note.poll!.totalVotes) votes in total")
                Text("•")
                Text("Refresh")
                    .onTapGesture {
                        self.viewReloader.reloadView()
                    }
                if note.poll!.votedForChoices != nil {
                    Text("•")
                    Text("Voted")
                }
                if note.poll!.expiredAfter != nil {
                    Text("•")
                    Text("Ends in \(note.poll!.expiredAfter!)")
                }
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 12))
        }
    }
}

#Preview {
    @State var note: NoteModel = .preview
    note.poll = .preview
    return NoteBodyPoll(note: note)
}
