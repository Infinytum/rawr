//
//  MessageModel.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import MisskeyKit
import Foundation

public extension MessageModel {
    static var preview: MessageModel {
        let JSON = """
{
    "id": "9icyc95sx3z3f1k9",
    "createdAt": "2023-08-13T11:53:51.712Z",
    "text": "Aight thank you for explanations And tutorial ^^",
    "userId": "9h6qyg5xy0",
    "user": {
        "id": "9h6qyg5xy0",
        "name": "random user",
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
    "recipientId": "9h6qyg5xy0",
    "groupId": null,
    "fileId": null,
    "file": null,
    "isRead": true,
    "reads": []
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(MessageModel.self, from: jsonData)
    }
    
}
