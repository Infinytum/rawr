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
    
    var body: some View {
        VStack {
            ForEach(self.getRenderedNote()) { view in
                AnyView(view.view)
            }
        }.sheet(isPresented: $presentHashtagSheet, content: {
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("#\(self.presentedHashtag)").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
            .font(.system(size: 20, weight: .thin)).padding(.top, 10)
            Timeline(timelineContext: HashtagTimelineContext(self.presentedHashtag))
        }).onAppear {
            guard let renderedNote = self.renderedNote else {
                return
            }
            self.registerContextHandlers(renderedNote.context)
        }
    }
    
    func getRenderedNote() -> [IdentifiableView] {
        if self.renderedNote != nil {
            return self.renderedNote!.renderedNote
        }
        
        let result = renderMFM(tokenize(self.note.text ?? ""), emojis: self.note.emojis ?? self.note.renote?.emojis ?? [])
        self.registerContextHandlers(result.context)
        self.renderedNote = renderedNote
        return result.renderedNote
    }
    
    func registerContextHandlers(_ context: RendererContext) {
        context.onHashtagTap { hashtag in
            self.presentedHashtag = hashtag
            self.viewRefresher.reloadView()
            self.presentHashtagSheet = true
        }
    }
}

#Preview {
    NoteBodyText(note: .preview.renote!)
        .previewDisplayName("Short")
        .environmentObject(ViewContext())
}
