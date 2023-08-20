//
//  Emoji.swift
//  rawr.
//
//  Created by Nila on 15.08.2023.
//

import MisskeyKit
import SwiftUI

struct Emoji: View {

    @EnvironmentObject var viewContext: ViewContext
    
    let name: String
    var emojis: [EmojiModel] = []
    
    @State var emojiUrl: String? = nil
    
    var body: some View {
        if self.emojiUrl == nil {
            Rectangle()
                .background(.clear)
                .foregroundColor(.clear)
                .onAppear {
                    Task {
                        self.emojiUrl = self.urlForEmoji(self.name)
                    }
                }
        } else {
            RemoteImage(self.emojiUrl)
        }
    }
    
    private func urlForEmoji(_ name: String) -> String? {
        return self.emojis.urlForEmoji(name) ?? self.viewContext.currentInstance?.emojis?.urlForEmoji(name)
    }
}

#Preview {
    VStack {
        Emoji(name: "drgn").environmentObject(ViewContext())
            .frame(width: 100, height: 100)
    }
}
