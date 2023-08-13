//
//  ChatHeader.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import SwiftUI

struct ChatHeader: View {
    
    @ObservedObject var context: ViewContext
    
    let history: MessageHistoryModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                RemoteImage(self.history.avatarUrl(currentUserId: self.context.currentUserId))
                    .frame(width: 40, height: 40)
                    .cornerRadius(11)
                VStack(alignment: .leading) {
                    Text(self.history.chatName(currentUserId: self.context.currentUser?.id ?? "") ?? "<No Name>")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text("Typing...").foregroundColor(.primary.opacity(0.7))
                        .font(.system(size: 16))
                        .padding(.top, -12)
                }
                Spacer()
            }.padding(.top, 10).padding(.bottom, 5)
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    ChatHeader(context: ViewContext(), history: .preview)
}
