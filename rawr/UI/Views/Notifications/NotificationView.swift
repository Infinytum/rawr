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
        VStack {
            if self.context.fetchError == nil {
                if self.context.firstLoadCompleted {
                    if self.context.items.isEmpty && !self.context.fetchingItems {
                        Spacer()
                        Text("Nothing to see here")
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(self.context.items) { notification in
                                    Notification(notification: notification)
                                        .padding(.horizontal)
                                        .onAppear(perform: {
                                            self.context.fetchItemsIfNeeded(notification)
                                        })
                                    Divider().padding(.vertical, 5)
                                }
                            }.padding(.top, 10).fluentBackground()
                        }
                        .safeAreaInset(edge: .bottom, spacing: 0, content: {
                            if self.context.fetchingItems && self.context.items.count > 0 {
                                ProgressView()
                                    .fluentBackground()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .clipped()
                                    .cornerRadius(.infinity)
                                    .shadow(radius: 10)
                            }
                        })
                        .refreshable {
                            self.context.initialize()
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
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
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            AppHeader {
                Text("Notifications")
            }
        }
        .onAppear(perform: self.context.initialize)
    }
}

#Preview {
    NotificationView()
        .environmentObject(ViewContext())
}
