//
//  Emoji.swift
//  rawr.
//
//  Created by Nila on 15.08.2023.
//

import MisskeyKit
import SwiftUI

fileprivate extension View {
    func applyEmojiRenderSize(size: CGSize?) -> AnyView {
        if size == nil {
            return AnyView(self)
        }
        return AnyView(self.frame(width: size!.width, height: size!.height))
    }
}

struct Emoji: View {

    @EnvironmentObject var viewContext: ViewContext
    @Environment(\.emojiRenderSize) var emojiRenderSize
    
    let name: String
    var emojis: [EmojiModel] = []
    var allowPopover: Bool = true
    
    
    @State var emojiUrl: String? = nil
    @State var presentEmojiPopover: Bool = false
    
    var body: some View {
        if self.emojiUrl == nil {
            Rectangle()
                .background(.clear)
                .foregroundColor(.clear)
                .onAppear {
                    Task {
                        self.emojiUrl = self.urlForEmoji(self.name) ?? ""
                    }
                }
        } else if self.emojiUrl == "" {
            Text(self.viewContext.defaultEmojis.charForEmoji(self.name) ?? self.name)
        } else {
            if self.allowPopover {
                remoteStaticEmoji
                    .popover(isPresented: $presentEmojiPopover, content: {
                        RemoteImage(self.emojiUrl)
                            .frame(width: 100, height: 100)
                            .padding()
                            .presentationCompactAdaptation(.popover)
                    })
                    .onTapGesture {
                        self.presentEmojiPopover = true
                    }
            } else {
                remoteStaticEmoji
            }
        }
    }
    
    var remoteStaticEmoji: some View {
        RemoteImage(self.emojiUrl)
            .applyEmojiRenderSize(size: self.emojiRenderSize)
    }
    
    private func urlForEmoji(_ name: String) -> String? {
        return self.emojis.urlForEmoji(name) ?? self.viewContext.currentInstance?.emojis?.urlForEmoji(name)
    }
}

#Preview {
    VStack {
        Emoji(name: "drgn", emojis: [.init(id: "drn", aliases: nil, name: "drgn", url: "https://cdn.derg.social/calckey/5e7735f5-5539-4993-be95-240147ca7476.png", uri: nil, category: "drgn")]).environmentObject(ViewContext())
            .frame(width: 30, height: 30)
    }
}
