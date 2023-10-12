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
        Group {
            if self.messagesContext.firstLoadCompleted {
                ScrollView {
                    if self.messagesContext.fetchingItems {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 100)
                    } else {
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
                }
                .refreshable {
                    self.messagesContext.initialize()
                }
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .safeAreaInset(edge: .top, spacing: 0, content: {
            AppHeader {
                Text("Messages")
            }
        })
    }
}

#Preview {
    MessagesView()
        .environmentObject(ViewContext())
}
