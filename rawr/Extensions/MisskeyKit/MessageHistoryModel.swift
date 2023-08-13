//
//  MessageHistoryModel.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import Foundation
import MisskeyKit

public extension MessageHistoryModel {
    static var preview: MessageHistoryModel {
        let JSON = """
{
    "id": "9ic2mr7clyqe1g1h",
    "createdAt": "2023-08-12T21:06:13.944Z",
    "text": "Before I just ramble about random stuff: Do you have any questions in particular?",
    "userId": "9h6qyg5xy0",
    "user": {
        "id": "9h6qyg5xy0",
        "name": "NilaTheDragon@derg.social:~# :idle:",
        "username": "nila",
        "host": null,
        "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-0d7ce0df-da12-4c06-9d9d-c10c1ec3fcfd.webp",
        "avatarBlurhash": "y4CYN?04}l[m0R};W@*zG@a2s;I-VGo[xG-.#:58^OEPOE~j0N-.Khz?P59I04~S$M0k~8Ibt3nNE2xu=_ERt2i_xnD+I;^$ES%KnR",
        "avatarColor": null,
        "isModerator": true,
        "isLocked": false,
        "speakAsCat": true,
        "emojis": [
            {
                "name": "idle",
                "url": "https://cdn.derg.social/calckey/8f5b03fb-987a-4df8-a3af-ca19f83978e5.png",
                "width": 500,
                "height": 500
            },
            {
                "name": "therian",
                "url": "https://cdn.derg.social/calckey/42935194-0d13-4d01-82a2-62d6596039ef.png",
                "width": 256,
                "height": 256
            }
        ],
        "onlineStatus": "online",
        "driveCapacityOverrideMb": null
    },
    "recipientId": "9h6qyg5xy0",
    "recipient": {
        "id": "9h6qyg5xy0",
        "name": "Some user",
        "username": "randomuser",
        "host": null,
        "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-0d7ce0df-da12-4c06-9d9d-c10c1ec3fcfd.webp",
        "avatarBlurhash": "yHKvBMjF~pM}~V%L-o^*ofxtxZRkWBM|D,My?F-.M{V[Rk-BtQNaWBV@juNH_1NGr@sojZNHs:xaxa%1tQa#WBxZtkkCaKxGWBX7oe",
        "avatarColor": null,
        "isLocked": false,
        "emojis": [],
        "onlineStatus": "active",
        "driveCapacityOverrideMb": null
    },
    "groupId": null,
    "fileId": null,
    "file": null,
    "isRead": false,
    "reads": []
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(MessageHistoryModel.self, from: jsonData)
    }
    
    func avatarUrl(currentUserId: String) -> String? {
        if self.userId == currentUserId {
            return self.recipient?.avatarUrl
        }
        return self.user?.avatarUrl
    }
    
    func chatName(currentUserId: String) -> String? {
        if self.userId == currentUserId {
            return self.recipient?.name ?? self.recipient?.username
        }
        return self.user?.name ?? self.user?.username
    }
    
    func isOwnMessage(currentUserId: String) -> Bool {
        return self.userId == currentUserId
    }
    
    func remoteUserId(currentUserId: String) -> String? {
        if self.userId == currentUserId {
            return self.recipientId
        }
        return self.userId
    }
    
    func text() -> String? {
        if self.text != nil {
            return self.text
        }
        
        if self.file?.name != nil {
            return self.file?.name
        }
        return nil
    }
    
}
