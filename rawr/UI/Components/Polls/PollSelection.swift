//
//  PollSelection.swift
//  rawr.
//
//  Created by Dråfølin on 8/27/23.
//

import SwiftUI
import MisskeyKit

struct PollSelection: View {
    @State var choice: Choice
    @State var note: NoteModel
    @State var voteAction: () -> Void
    
    var body: some View {
        Button {
            voteAction()
        } label: {
            Text(choice.text ?? "")
                .multilineTextAlignment(.leading)
            Spacer()
            if choice.isVoted ?? false {
                Image(systemName: "checkmark.circle")
            }
            if (note.poll?.totalVotes ?? 0) != 0 {
                Text("\((choice.votes ?? 0) * 100 / note.poll!.totalVotes)%")
                Text("(\(choice.votes ?? 0))")
            }
        }
        .buttonStyle(.bordered)
        .foregroundStyle(.primary)
        .disabled(note.poll?.votedForChoices != nil)
        .background {
            GeometryReader {buttonFrame in
                if note.poll?.votedForChoices != nil {
                    (choice.isVoted ?? false ?
                     Color.blue :                  Color.gray)
                    .frame(width: CGFloat(choice.votes ?? 0) * buttonFrame.size.width / CGFloat(note.poll!.totalVotes))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    let choice: Choice = Poll.preview.choices![0]!
    return PollSelection(choice: choice, note: NoteModel.preview, voteAction: {}).environmentObject(ViewContext())
}
