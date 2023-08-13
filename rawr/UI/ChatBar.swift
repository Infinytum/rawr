//
//  ChatBar.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import SwiftUI

struct ChatBar: View {
    
    
    @State var messagetext: String = ""
    
    @ObservedObject var chatContext: ChatContext
    
    var messageIsEmpty: Bool {
        return messagetext.count == 0
    }

    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: self.$messagetext, axis: .vertical)
                    .lineLimit(...5)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(15)
                Button(action: self.onSend) {
                    Image(systemName: "arrow.up")
                        .frame(width: 18, height: 18)
                        .padding(.all, 5)
                        .background(
                            self.messageIsEmpty ? .gray : .blue
                        )
                        .foregroundColor(.white)
                }
                .cornerRadius(.infinity)
                .disabled(self.messageIsEmpty)
            }
        }.padding(.horizontal).padding(.vertical, 10).background(.thinMaterial)
    }
    
    private func onSend() {
        MisskeyKit.shared.messaging.create(userId: self.chatContext.remoteUserId, text: self.messagetext) { message, error in
            guard let message = message else {
                print("Error sending chat message")
                print(error ?? "")
                return
            }
            self.messagetext = ""
        }
    }
}

#Preview {
    ChatBar(chatContext: ChatContext())
}
