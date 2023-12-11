//
//  Notification.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import MisskeyKit
import SwiftUI

struct Notification: View {
    
    @EnvironmentObject var context: ViewContext
    
    let notification: NotificationModel
    
//    @State var noteExpanded: Bool = true
    
    var body: some View {
        VStack {
            HStack() {
                RemoteImage(notification.user?.avatarUrl ?? self.context.currentInstance?.getIconUrl())
                    .frame(width: 50, height: 50)
                    .cornerRadius(11)
                    .overlay(alignment: .bottomTrailing) {
                        VStack {
                            Image(systemName: self.icon())
                                .foregroundColor(.black)
                                .frame(width: 12, height: 12)
                        }.padding(.all, 8).background(.white).cornerRadius(.infinity).offset(x: 5.0, y: 5.0).shadow(radius: 1)
                    }
                VStack(alignment: .leading) {
                    HStack {
                        self.titleBody
                            .environment(\.emojiRenderSize, CGSize(width: 18, height: 18))
                            .font(.system(size: 18))
                            .frame(maxHeight: 21, alignment: .top)
                            .clipped()
                            .lineLimit(1, reservesSpace: false)
                        Spacer()
                        RelativeDate(date: self.notification.createdAt!.toDate()!)
                            .font(.system(size: 16))
                            .foregroundColor(.primary.opacity(0.7))
                            .lineLimit(1, reservesSpace: true)
                    }
                    HStack {
                        Text(self.subtitle())
                            .foregroundColor(.primary.opacity(0.7))
                            .font(.system(size: 16, weight: .regular))
                            .lineLimit(2)
                            .overlay(alignment: .trailing) {
                                if self.notification.reaction != nil {
                                    Emoji(name: self.notification.reaction!, emojis: self.notification.note?.reactionEmojis ?? [])
                                        .environment(\.emojiRenderSize, CGSize(width: 25, height: 25))
                                        .offset(x: 25)
                                }
                            }
                    }
                }.padding(.leading, 5)
                Spacer()
            }
            if self.notification.note != nil {
                NoteQuoteComponent(note: self.mainNote())
            }
        }
    }
    
    private func icon() -> String {
        guard let type = self.notification.type else {
            return "questionmark"
        }
        switch type {
        case .follow:
            return "hand.wave"
        case .mention:
            return "at"
        case .reply:
            return "text.bubble"
        case .renote:
            return "arrow.2.squarepath"
        case .quote:
            return "quote.bubble"
        case .reaction:
            return "hands.sparkles"
        case .pollVote, .pollEnded:
            return "music.mic"
        case .receiveFollowRequest:
            return "questionmark"
        case .followRequestAccepted:
            return "checkmark"
        case .achievementEarned:
            return "trophy"
        }
    }
    
    private func subtitle() -> String {
        guard let type = self.notification.type else {
            return "This notification has no type"
        }
        switch type {
        case .follow:
            return "is now following you"
        case .mention:
            return "mentioned you in a note"
        case .reply:
            return "replied to your note"
        case .renote:
            return "boosted your note"
        case .quote:
            return "quote-boosed your note"
        case .reaction:
            return "reacted to your note with "
        case .pollVote:
            return "voted on your poll"
        case .pollEnded:
            return "The results of a poll you participated in are in!"
        case .receiveFollowRequest:
            return "would like to follow you"
        case .followRequestAccepted:
            return "accepted your follow request"
        case .achievementEarned:
            return "You earned an achievement"
        }
    }
    
    var titleBody: some View {
        switch self.notification.type {
        case nil:
            return AnyView(Text("Unknown Notification"))
        case .follow, .mention, .reply, .renote, .quote, .reaction, .receiveFollowRequest, .followRequestAccepted, .pollVote:
            return AnyView(MFMBody(render: self.notification.user.renderedDisplayName()))
        case .pollEnded:
            return AnyView(Text("Poll Results"))
        case .achievementEarned:
            return AnyView(Text("Achievement earned!"))
        }
    }
    
    private func mainNote() -> NoteModel {
        if self.notification.note!.isRenote() {
            if self.notification.note!.isQuoteRenote() {
                return self.notification.note!
            }
            return self.notification.note!.renote!
        }
        return self.notification.note!
    }
}

#Preview {
    VStack {
        Notification(notification: .preview)
            .listRowInsets(.none)
    }.padding().environmentObject(ViewContext())
}
