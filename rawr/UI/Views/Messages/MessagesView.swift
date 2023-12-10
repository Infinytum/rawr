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
                            LazyVStack(spacing: 0) {
                                ForEach(self.messagesContext.items, id: \.id) { item in
                                    NavigationLink(destination: MessageView(history: item).navigationBarBackButtonHidden(true)) {
                                        MessagesListEntry(history: item)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                    if item.id != self.messagesContext.items.last?.id {
                                        Divider()
                                            .padding(.top, 10)
                                            .padding(.bottom, 15)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .padding(.top)
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
            BetterAppHeader {
                AppHeaderSimpleBody {
                    Text("Messages")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus.message")
                        .font(.system(size: 20))
                }.disabled(true)
            }
        })
    }
}

#Preview {
    NavigationStack {
        MessagesView()
            .environmentObject(ViewContext())
    }
}
