//
//  Note.swift
//  rawr.
//
//  Created by Nila on 02.12.2023.
//

import MisskeyKit
import SwiftUI

enum NoteComponents: Identifiable {
    var id: Self {
        return self
    }
    
    /// Note which has been replied to
    case parentHeader
    case parentBody
    
    /// Note which has been quoted
    case quotedNote
    
    /// Main Note
    case boostDecoration
    case header
    case body
    case reactions
    case footer
}

struct Note: View {
    
    let note: NoteModel
    /// Default Note Receipe
    /// 1. Reply Parent
    /// 2. Boost Decoration
    /// 3. Header of main note
    /// 4. Body of main note
    /// 5. Quoted note
    /// 6. Reactons of main note
    /// 7. Footer of main note
    ///
    /// For replies, the parent note is rendered above the main note
    /// They are connected through a line on the left side of the parent note.
    var components: [NoteComponents] = [
        .parentHeader,
        .parentBody,
        .boostDecoration,
        .header,
        .body,
        .quotedNote,
        .reactions,
        .footer
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(self.components) { component in
                switch component {
                case .boostDecoration:
                    /// Only show the boost decoration if it's a renote. A quote does not need the decoration!
                    if self.note.isRenote() && !self.note.isQuoteRenote() {
                        self.componentBoostDecoration
                    }
                case .parentHeader:
                    if self.note.reply != nil {
                        self.componentParentHeader
                    }
                case .parentBody:
                    if self.note.reply != nil {
                        self.componentParentBody
                    }
                case .header:
                    self.componentHeader
                case .body:
                    self.componentBody
                case .quotedNote:
                    if self.note.isQuoteRenote() {
                        self.componentQuotedNote
                    }
                case .reactions:
                    if self.mainNote().reactionsCount() > 0 {
                        self.componentReactions
                    }
                case .footer:
                    self.componentFooter
                }
            }
        }
    }
    
    var componentBody: some View {
        NavigationLink(value: NoteLink(id: self.mainNote().id!)) {
            NoteBody(note: self.mainNote())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 5)
    }
    
    var componentBoostDecoration: some View {
        NoteDecorationBoost(note: self.note)
            .padding(.bottom, 10)
    }
    
    var componentFooter: some View {
        NoteFooter(note: self.mainNote())
            .padding(.top, 5)
    }
    
    var componentHeader: some View {
        NoteHeader(note: self.mainNote())
    }
    
    var componentQuotedNote: some View {
        NoteQuoteComponent(note: self.note.renote!)
    }
    
    var componentReactions: some View {
        NoteBodyReactions(note: self.mainNote())
            .padding(.top, 5)
    }
    
    var componentParentHeader: some View {
        NoteHeader(note: self.note.reply!)
    }
    
    var componentParentBody: some View {
        VStack {
            NavigationLink(value: NoteLink(id: self.note.replyId!)) {
                NoteBody(note: self.note.reply!)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.leading, 50)
        .overlay(alignment: .leading) {
            Rectangle()
                .frame(width: 3)
                .padding(.leading, 23)
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
    }
    
    /// Choose the main note to render. Usually this is the root note
    /// but in case of a plain renote, the renote is the main note
    private func mainNote() -> NoteModel {
        if self.note.isRenote() {
            if self.note.isQuoteRenote() {
                return self.note
            }
            return self.note.renote!
        }
        return self.note
    }
}

#Preview {
    Note(note: .previewRenote)
        .padding(.horizontal)
        .previewDisplayName("Renote")
}

#Preview {
    Note(note: .previewReply)
        .padding(.horizontal)
        .previewDisplayName("Reply")
}

#Preview {
    ScrollView {
        Note(note: .previewQuote)
            .padding(.horizontal)
    }
    .previewDisplayName("Quote")
}
