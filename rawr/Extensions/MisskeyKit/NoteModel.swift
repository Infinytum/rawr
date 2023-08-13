//
//  NoteModel.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import Foundation
import MisskeyKit

extension NoteModel: ObservableObject {
    static var preview: NoteModel {
        let JSON = """
{
    "id": "9i34idf3o2udblyb",
    "createdAt": "2023-08-06T14:48:53.103Z",
    "userId": "9h7suzflja",
    "user": {
      "id": "9h7suzflja",
      "name": "Zander",
      "username": "Zander",
      "host": null,
      "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-478f89d2-856b-4943-bca2-0dfdf035ed71.webp",
      "avatarBlurhash": "yYK-Cq:+Q7P7T0S+V@PVburXi~j?WAOsP;OWNGTKV[n$wIo}V]S6rqs-o|S2I@r@z;jEbInhX8Sjbvr=eobti{s,S$XRkBo2jEbcX9",
      "avatarColor": null,
      "isLocked": false,
      "speakAsCat": true,
      "emojis": [
        {
          "name": "therian",
          "url": "https://cdn.derg.social/calckey/42935194-0d13-4d01-82a2-62d6596039ef.png",
          "width": 256,
          "height": 256
        },
        {
          "name": "dragnheart",
          "url": "https://cdn.derg.social/calckey/6c7c5863-c4a5-441a-93bf-4b304e811170.png",
          "width": 128,
          "height": 128
        }
      ],
      "onlineStatus": "online",
      "driveCapacityOverrideMb": null
    },
    "text": null,
    "cw": null,
    "visibility": "public",
    "renoteCount": 0,
    "repliesCount": 0,
    "reactions": {},
    "reactionEmojis": [],
    "emojis": [],
    "fileIds": [],
    "files": [],
    "replyId": null,
    "renoteId": "9i34eelcop7lmzf9",
    "renote": {
      "id": "9i34eelcop7lmzf9",
      "createdAt": "2023-08-06T14:45:48.000Z",
      "userId": "9huco42pj13clw1l",
      "user": {
        "id": "9huco42pj13clw1l",
        "name": "NitroDS",
        "username": "NitroDS",
        "host": "meow.social",
        "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-cec48dd2-7e0d-48ec-9986-43650e903923.webp",
        "avatarBlurhash": "yIC$7r0e%gv~%gSgxa_NIAyDrr-;Szs:~CE1%gV@-pXSWB?HNG%Mi_kq%2ayxun$tRoLs:tRn*xGX8t7t7W:t7aeW;t7bGt7f6t7WV",
        "avatarColor": null,
        "isLocked": false,
        "speakAsCat": true,
        "instance": {
          "name": "meow.social - the mastodon instance for creatures fluffy, scaly and otherwise",
          "softwareName": "mastodon",
          "softwareVersion": "4.1.4",
          "iconUrl": "https://meow.social/packs/media/icons/android-chrome-36x36-4c61fdb42936428af85afdbf8c6a45a8.png",
          "faviconUrl": "https://meow.social/packs/media/icons/favicon-48x48-c1197e9664ee6476d2715a1c4293bf61.png",
          "themeColor": "#191b22"
        },
        "emojis": [],
        "onlineStatus": "unknown",
        "driveCapacityOverrideMb": null
      },
      "text": "#dragon #furry #art #angry #roar #fire",
      "cw": null,
      "visibility": "public",
      "renoteCount": 2,
      "repliesCount": 0,
      "myReaction": ":dragnyell@.:",
      "reactions": {
        ":dragnyell@.:": 1,
        ":dragnstar@.:": 12
      },
      "reactionEmojis": [
        {
          "name": "dragnstar@.",
          "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
          "width": 128,
          "height": 128
        },
        {
          "name": "dragnyell@.",
          "url": "https://cdn.derg.social/calckey/5f1ac2fc-0ade-481f-a1c2-7da22e744da3.png",
          "width": 128,
          "height": 128
        }
      ],
      "emojis": [
        {
          "name": "dragnstar@.",
          "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
          "width": 128,
          "height": 128
        },
        {
          "name": "dragnyell@.",
          "url": "https://cdn.derg.social/calckey/5f1ac2fc-0ade-481f-a1c2-7da22e744da3.png",
          "width": 128,
          "height": 128
        }
      ],
      "tags": [
        "dragon",
        "furry",
        "art",
        "angry",
        "roar",
        "fire"
      ],
      "fileIds": [
        "9i34efk3d3df9jo4"
      ],
      "files": [
        {
          "id": "9i34efk3d3df9jo4",
          "createdAt": "2023-08-06T14:45:49.251Z",
          "name": "a2d1b01faabe9668.png",
          "type": "image/png",
          "md5": "9f2787c1c572e9cf0a7f35c784ec8f94",
          "size": 1151754,
          "isSensitive": false,
          "blurhash": "y6AuUJI;}9#+AGWBS|23$%1HSdwzNu$j}DJV-5I@-Aw|WX1G=eNa$*W=bbNc;KJ8xYogS$sBWW0}W-j[t7xGs+jF,@#,$%W?$hWCWU",
          "properties": {
            "width": 800,
            "height": 1200
          },
          "url": "https://cdn.derg.social/calckey/b00ca429-2ee8-498f-a66b-155122ba67f6.png",
          "thumbnailUrl": "https://cdn.derg.social/calckey/thumbnail-48705fca-5a0a-44dc-be3d-be43366582aa.webp",
          "comment": "an angry dragon atop a castle roaring",
          "folderId": null,
          "folder": null,
          "userId": null,
          "user": null
        }
      ],
      "replyId": null,
      "renoteId": null,
      "uri": "https://meow.social/users/NitroDS/statuses/110843209221961331",
      "url": "https://meow.social/@NitroDS/110843209221961331",
      "updatedAt": "2023-08-06T14:49:47.755Z"
    }
  }
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(NoteModel.self, from: jsonData)
    }
    
    typealias NoteVisibility = Visibility
    
    // MARK: Commands
    
    // MARK: Reactions
    
    /// Get the URL for any reaction that is present on this note
    func emojiUrlForReaction(name: String) -> String {
        guard let emojis = self.emojis else {
            return ""
        }
        
        guard let foundEmoji = emojis.filter({ emoji in
            ":" + (emoji.name ?? "") + ":" == name
        }).first else {
            return ""
        }
        
        return foundEmoji.url ?? ""
    }
    
    /// Check whether the given reaction is already the users reaction for this note
    func isMyReaction(_ reaction: String) -> Bool {
        return (self.myReaction ?? "") == reaction
    }
    
    /// Add a reactions to the note, replacing any existing reaction
    func react(_ reaction: String) async throws {
        if (self.myReaction ?? "") == reaction { return; }
        
        // Handle existing reaction and remove it if necessary
        try await self.unreact()
        
        return try await withCheckedThrowingContinuation { continuation in
            MisskeyKit.shared.notes.createReaction(noteId: self.id!, reaction: reaction) { _, error in
                guard let error = error else {
                    self.myReaction = reaction
                    self.reactions![self.myReaction!]! += 1
                    self.objectWillChange.send()
                    continuation.resume()
                    return
                }
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Remove any existing reaction from the note
    func unreact() async throws {
        guard let _ = self.myReaction else { return }
        return try await withCheckedThrowingContinuation { continuation in
            MisskeyKit.shared.notes.deleteReaction(noteId: self.id!) { _, error in
                guard let error = error else {
                    self.reactions![self.myReaction!]! -= 1
                    self.myReaction = nil
                    self.objectWillChange.send()
                    continuation.resume()
                    return
                }
                continuation.resume(throwing: error)
            }
        }
    }
    
    func reactionsCount() -> Int {
        guard let reactions = self.reactions else {
            return 0
        }
        
        var total = 0
        for pair in reactions {
            total += pair.value
        }
        return total
    }
    
    // MARK: Random Helper Functions
    
    func hasFiles() -> Bool {
        return isRenote() ? self.renote?.files != nil : self.files != nil
    }
    
    func isRenote() -> Bool {
        return self.renote != nil
    }

    func relativeCreatedAtTime() -> String {
        guard let createdAt = self.createdAt else {
            return "Unknown"
        }
        
        guard let createdAtDate = createdAt.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") else {
            return "Parse failed"
        }
        
        return createdAtDate.relative()
    }
}
