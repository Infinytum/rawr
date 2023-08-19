//
//  ChatBar.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import SwiftUI

struct ChatBar: View {
    
    @EnvironmentObject var context: ViewContext
    
    @ObservedObject var chatContext: ChatContext
    @State var messageText: String = ""
    @State var sendInProgress: Bool = false
    
    var messageIsEmpty: Bool {
        return messageText.count == 0
    }

    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: self.$messageText, axis: .vertical)
                    .lineLimit(...5)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(15)
                if self.sendInProgress {
                    ProgressView()
                        .frame(width: 18, height: 18)
                        .padding(.all, 5)
                } else {
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
            }
        }.padding(.horizontal).padding(.vertical, 10).background(.thinMaterial)
    }
    
    private func onSend() {
        self.sendInProgress = true
        let messageText = self.messageText
        self.messageText = ""
        MisskeyKit.shared.messaging.create(userId: self.chatContext.remoteUserId, text: messageText) { message, error in
            self.sendInProgress = false
            guard let _ = message else {
                self.messageText = messageText
                self.context.applicationError = ApplicationError(title: "Chat Message failed", message: error.explain())
                print("ChatBar Error: API returned error while sending message: \(error!)")
                return
            }
        }
    }
}

#Preview {
    ChatBar(chatContext: ChatContext())
}
