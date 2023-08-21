//
//  NotificationView.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import MisskeyKit
import SwiftUI

struct NotificationView: View {
    
    @ObservedObject var context: NotificationContext = NotificationContext()
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var noteId: String = ""
    @State var noteDetailShown: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if self.context.fetchError == nil {
                    
                } else {
                    Spacer()
                    Text("Couldn't fetch Notifications")
                        .font(.system(size: 20, weight: .regular))
                    Text(self.context.fetchError!)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                if self.context.items.isEmpty && !self.context.fetchingItems {
                    Spacer()
                    Text("Nothing to see here")
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(self.context.items) { notification in
                                Notification(notification: notification)
                                    .onAppear(perform: {
                                        self.context.fetchItemsIfNeeded(notification)
                                    })
                                    .onTapGesture {
                                        if notification.note != nil {
                                            self.noteId = notification.note!.id!
                                            self.viewReloader.reloadView()
                                            self.noteDetailShown = true
                                        }
                                    }.padding(.horizontal, 1)
                                Divider().padding(.vertical, 5)
                            }
                            if self.context.fetchingItems {
                                ProgressView()
                            }
                        }.padding(.horizontal).padding(.top, 10)
                    }
                }
            }.padding(.top, 55)
            .sheet(isPresented: self.$noteDetailShown) {
                NoteView(noteId: self.noteId)
            }
            NotificationHeader()
        }.onAppear(perform: self.context.initialize)
    }
}

#Preview {
    NotificationView()
        .environmentObject(ViewContext())
}
