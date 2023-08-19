//
//  ChatView.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import SwiftUI
import MisskeyKit

struct ChatListView: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewReloader: ViewReloader = ViewReloader()
    
    @State var histories: [MessageHistoryModel]? = nil
    @State var selectedHistory: MessageHistoryModel? = nil
    @State var chatSheetShown: Bool = false
    
    var body: some View {
        let chatSheetShownProxy = Binding<Bool>(get: {
                    self.chatSheetShown
                }, set: {
                    self.chatSheetShown = $0
                    self.loadChatHistory()
                })
        
        ZStack(alignment: .top) {
            VStack {
                if self.histories == nil {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if self.histories!.count == 0 {
                    Spacer()
                    Text("Nothing to see here")
                    Spacer()
                } else {
                    List {
                        ForEach(self.histories ?? [], id: \.id) { item in
                            ChatListEntry(history: item).listRowInsets(EdgeInsets(top: 10,leading: 0,bottom: 10,trailing: 0))
                                .onTapGesture {
                                    self.selectedHistory = item
                                    self.viewReloader.reloadView()
                                    self.chatSheetShown = true
                                }
                        }
                    }.listStyle(.plain)
                }
            }.padding(.horizontal).padding(.top, 55)
            ChatListHeader()
        }.onAppear(perform: self.loadChatHistory).sheet(isPresented: chatSheetShownProxy) {
            ChatView(history: self.selectedHistory!)
        }
    }
    
    private func loadChatHistory() {
        MisskeyKit.shared.messaging.getHistory { histories, error in
            guard let histories = histories else {
                self.context.applicationError = ApplicationError(title: "Fetching Chats failed", message: error.explain())
                print("ChatListView Error: API returned error while fetching chats: \(error!)")
                self.histories = []
                return
            }
            self.histories = histories
        }
    }
}

#Preview {
    ChatListView(histories: [.preview, .preview, .preview])
        .environmentObject(ViewContext())
}
