//
//  NotificationView.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import MisskeyKit
import SwiftUI

struct NotificationView: View {
    
    @State var notifications: [NotificationModel]?
    @State var noteId: String = ""
    @State var noteDetailShown: Bool = false
    @ObservedObject var viewReloader = ViewReloader()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if self.notifications == nil {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if self.notifications!.isEmpty {
                    Spacer()
                    Text("Nothing to see here")
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(self.notifications!) { notification in
                            Notification(notification: notification)
                                .onTapGesture {
                                    if notification.note != nil {
                                        self.noteId = notification.note!.id!
                                        self.viewReloader.reloadView()
                                        self.noteDetailShown = true
                                    }
                                }.padding(.horizontal, 1)
                            Divider().padding(.vertical, 5)
                        }
                    }.padding(.top, 10)
                }
            }.padding(.horizontal).padding(.top, 55)
            .sheet(isPresented: self.$noteDetailShown) {
                NoteView(noteId: self.noteId)
            }
            NotificationHeader()
        }.onAppear(perform: self.onAppear)
    }
    
    private func onAppear() {
        print("Fetching Notifications")
        MisskeyKit.shared.notifications.get(following: false) { notifications, error in
            guard let notifications = notifications else {
                print("NotificationView Error: Unable to fetch notifications: \(error!)")
                self.notifications = [.preview, .preview]
                return
            }
            
            self.notifications = notifications
        }
    }
}

#Preview {
    NotificationView()
        .environmentObject(ViewContext())
}
