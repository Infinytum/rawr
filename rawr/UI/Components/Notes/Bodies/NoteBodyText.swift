//
//  NoteBodyText.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteBodyText: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewRefresher = ViewReloader()
    
    let note: NoteModel
    @State var renderedNote: MFMRender? = nil
    
    @State var presentHashtagSheet = false
    @State var presentedHashtag = ""
    
    @State var presentUserSheet = false
    @State var presentedUser = ""
    
    var body: some View {
        VStack {
            ForEach(self.getRenderedNote()) { view in
                AnyView(view.view)
            }
        }.sheet(isPresented: $presentHashtagSheet, content: {
            HashtagTimelineHeader(presentedHashtag: self.presentedHashtag)
            Timeline(timelineContext: HashtagTimelineContext(self.presentedHashtag))
        }).sheet(isPresented: $presentUserSheet) {
            UserView(userName: presentedUser)
        }.onAppear {
            guard let renderedNote = self.renderedNote else {
                return
            }
            self.registerContextHandlers(renderedNote.context)
        }
    }
    
    func getRenderedNote() -> MFMRenderViewStack {
        if self.renderedNote != nil {
            return self.renderedNote!.renderedNote
        }
        
        let result = mfmRender(tokenize(self.note.text ?? ""), emojis: self.note.emojis ?? self.note.renote?.emojis ?? [])
        self.registerContextHandlers(result.context)
        return result.renderedNote
    }
    
    func registerContextHandlers(_ context: MFMRenderContext) {
        context.onHashtagTap { hashtag in
            self.presentedHashtag = hashtag
            self.viewRefresher.reloadView()
            self.presentHashtagSheet = true
        }
        
        context.onMentionTap { username in
            self.presentedUser = username
            self.viewRefresher.reloadView()
            self.presentUserSheet = true
        }
    }
}

#Preview {
    NoteBodyText(note: .preview.renote!)
        .previewDisplayName("Short")
        .environmentObject(ViewContext())
}
