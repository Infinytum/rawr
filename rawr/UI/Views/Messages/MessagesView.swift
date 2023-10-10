//
//  MessagesView.swift
//  rawr.
//
//  Created by Nila on 06.10.2023.
//

import MisskeyKit
import SwiftKit
import SwiftUI

struct MessagesView: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var messagesContext: MessagesContext = MessagesContext()
    
    public init() {
        self.messagesContext.initialize()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVStack() {
                    ForEach(self.messagesContext.items, id: \.id) { item in
                        NavigationLink(destination: MessageView(history: item).navigationBarBackButtonHidden(true)) {
                            MessagesListEntry(history: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        Divider()
                            .foregroundStyle(.gray.opacity(0.3))
                            .frame(height: 0.5)
                    }
                }.padding(.top)
            }.fluentBackground()
        }
        .safeAreaInset(edge: .top, spacing: 0, content: {
            AppHeader {
                Text("Messages")
            }
        })
        .refreshable {
            self.messagesContext.initialize()
        }
    }
}

#Preview {
    MessagesView()
        .environmentObject(ViewContext())
}
