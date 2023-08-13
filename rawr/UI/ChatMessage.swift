//
//  ChatMessage.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import SwiftUI

struct ChatMessage: View {
    
    let chatMessage: MessageModel
    let remote: Bool
    
    var body: some View {
        VStack(alignment: self.remote ? .leading : .trailing) {
            HStack{ Spacer() }.frame(height: 0)
            VStack {
                Text(self.chatMessage.text ?? "").foregroundColor(.white)
            }.padding(.all, 10).background(self.remote ? .gray : .blue).cornerRadius(15)
        }
    }
}

#Preview {
    List {
        ChatMessage(chatMessage: .preview, remote: true)
            .listRowSeparator(.hidden)
        ChatMessage(chatMessage: .preview, remote: false)
            .listRowSeparator(.hidden)
    }.listStyle(.plain)
}
