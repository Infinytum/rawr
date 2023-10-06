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
        NavigationStack {
            ZStack {
                VStack {
                    AppHeader {
                        Text("Messages")
                    }
                    ScrollView {
                        LazyVStack() {
                            ForEach(self.messagesContext.items, id: \.id) { item in
                                NavigationLink(destination: MessageView(history: item).navigationBarBackButtonHidden(true)) {
                                    MessagesListEntry(history: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                Divider()
                            }
                        }.padding(.top)
                    }
                    .fluentBackground()
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    Spacer()
                }
                .refreshable {
                    self.messagesContext.initialize()
                }
                .background(context.themeBackground.ignoresSafeArea())
            }
        }
    }
}

#Preview {
    MessagesView()
        .environmentObject(ViewContext())
}
