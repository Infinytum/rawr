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

    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: self.$messagetext, axis: .vertical)
                    .lineLimit(...5)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(15)
                Image(systemName: "arrow.up")
                    .frame(width: 18, height: 18)
                    .padding(.all, 5)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(.infinity)
                    .onTapGesture(perform: self.onSend)
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
            self.chatContext.items.insert(message, at: 0)
        }
    }
}

#Preview {
    ChatBar(chatContext: ChatContext(remoteUserId: ""))
}
