//
//  ChatListHeader.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import SwiftUI

struct ChatListHeader: View {
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                ProfileSwitcher()
                    .frame(width: 40, height: 40)
                Spacer()
            }
            VStack {
                Text("Derg Social").font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("Chats").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    ChatListHeader()
}
