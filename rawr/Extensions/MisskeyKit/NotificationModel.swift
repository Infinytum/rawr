//
//  NotificationModel.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import Foundation
import MisskeyKit

extension NotificationModel: Identifiable {
    static var preview: NotificationModel {
        let JSON = """
{
    "id": "9igz9e88m5zicv6d",
    "createdAt": "2023-08-16T07:30:42.632Z",
    "type": "mention",
    "isRead": true,
    "userId": "9hog5n16vcey3ix0",
    "user": {
        "id": "9hog5n16vcey3ix0",
        "name": "(っ◔◡◔)っ ✨ Rudzik ✨🔜EF :idle:",
        "username": "Rudzik",
        "host": "meow.social",
        "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-5b5f08d7-3580-4398-b93d-2dff5a6ad69e.webp",
        "avatarBlurhash": "y8ASS[?H.5NGaJMxIU~D?HXjNGInIBMxTv-p%2RjVsIUMx%ytS-VRkV@M_IV%ftR%2afV@RPM{TJxuogspjERjVstQS~xGn+axjERj",
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
        "emojis": [
            {
                "name": "idle",
                "url": "https://derg.social/proxy/%2Fcustom_emojis%2Fimages%2F000%2F286%2F136%2Foriginal%2F8b43b60b164bce0a.png?url=https%3A%2F%2Fmedias.meow.social%2Fcustom_emojis%2Fimages%2F000%2F286%2F136%2Foriginal%2F8b43b60b164bce0a.png",
                "width": 500,
                "height": 500
            }
        ],
        "onlineStatus": "unknown",
        "driveCapacityOverrideMb": null
    },
    "note": {
        "id": "9igz9cywwc8fir6m",
        "createdAt": "2023-08-16T07:30:41.000Z",
        "userId": "9hog5n16vcey3ix0",
        "user": {
            "id": "9hog5n16vcey3ix0",
            "name": "(っ◔◡◔)っ ✨ Rudzik ✨🔜EF :idle:",
            "username": "Rudzik",
            "host": "meow.social",
            "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-5b5f08d7-3580-4398-b93d-2dff5a6ad69e.webp",
            "avatarBlurhash": "y8ASS[?H.5NGaJMxIU~D?HXjNGInIBMxTv-p%2RjVsIUMx%ytS-VRkV@M_IV%ftR%2afV@RPM{TJxuogspjERjVstQS~xGn+axjERj",
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
            "emojis": [
                {
                    "name": "idle",
                    "url": "https://derg.social/proxy/%2Fcustom_emojis%2Fimages%2F000%2F286%2F136%2Foriginal%2F8b43b60b164bce0a.png?url=https%3A%2F%2Fmedias.meow.social%2Fcustom_emojis%2Fimages%2F000%2F286%2F136%2Foriginal%2F8b43b60b164bce0a.png",
                    "width": 500,
                    "height": 500
                }
            ],
            "onlineStatus": "unknown",
            "driveCapacityOverrideMb": null
        },
        "text": "@Gandhithedergrawr@derg.social @nila@derg.social @ReikoAldrakar@derg.social \\nThank you guys 😭​ this made my day honstly",
        "cw": null,
        "visibility": "public",
        "renoteCount": 0,
        "repliesCount": 0,
        "reactions": {
            ":dragnheart@.:": 3
        },
        "reactionEmojis": [
            {
                "name": "dragnstar@.",
                "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
                "width": 128,
                "height": 128
            },
            {
                "name": "dragnheart@.",
                "url": "https://cdn.derg.social/calckey/6c7c5863-c4a5-441a-93bf-4b304e811170.png",
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
                "name": "dragnheart@.",
                "url": "https://cdn.derg.social/calckey/6c7c5863-c4a5-441a-93bf-4b304e811170.png",
                "width": 128,
                "height": 128
            }
        ],
        "fileIds": [],
        "files": [],
        "replyId": "9ig0jbv1rdv5a14g",
        "renoteId": null,
        "mentions": [
            "9hpu5tn1uqjzkx0j",
            "9h6qyg5xy0",
            "9i1wwqr4lisnjqgf"
        ],
        "uri": "https://meow.social/users/Rudzik/statuses/110898121388932308",
        "url": "https://meow.social/@Rudzik/110898121388932308",
        "myReaction": ":dragnheart@.:",
        "reply": {
            "id": "9ig0jbv1rdv5a14g",
            "createdAt": "2023-08-15T15:18:39.565Z",
            "userId": "9hpu5tn1uqjzkx0j",
            "user": {
                "id": "9hpu5tn1uqjzkx0j",
                "name": "GandhiTheDerg",
                "username": "Gandhithedergrawr",
                "host": null,
                "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-36c46109-4371-4256-b4c6-2a70a42f401e.webp",
                "avatarBlurhash": "yPD*LvOp}XEz$iEze:%2=bJ-$iJRaxNuaiR+I?oLayoLazoNNIR-o2sUs:sow|R-j]jbsnn,j[jcs.NbWWn+S4f8oLsmNwWXWWWWWV",
                "avatarColor": null,
                "isLocked": false,
                "speakAsCat": true,
                "emojis": [],
                "onlineStatus": "online",
                "driveCapacityOverrideMb": null
            },
            "text": "@ReikoAldrakar @nila @Rudzik@meow.social THE FUR ESPECIALLY\\nI love the fur, it looks so FLOOFY AND SOFT",
            "cw": null,
            "visibility": "public",
            "renoteCount": 0,
            "repliesCount": 1,
            "reactions": {
                ":dragnstar@.:": 2
            },
            "reactionEmojis": [
                {
                    "name": "dragnstar@.",
                    "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
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
                }
            ],
            "fileIds": [],
            "files": [],
            "replyId": "9ibkyv64n12km7fy",
            "renoteId": null,
            "mentions": [
                "9i1wwqr4lisnjqgf",
                "9h6qyg5xy0",
                "9hog5n16vcey3ix0"
            ]
        }
    }
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(NotificationModel.self, from: jsonData)
    }
}
