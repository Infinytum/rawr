//
//  UserModel.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import Foundation
import MisskeyKit

extension UserModel {
    
    static var preview: UserModel {
        let JSON = """
{
    "id": "9h6qyg5xy0",
    "name": "NilaTheDragon@derg.social:~# :idle:",
    "username": "nila",
    "host": null,
    "avatarUrl": "https://cdn.derg.social/calckey/thumbnail-0d7ce0df-da12-4c06-9d9d-c10c1ec3fcfd.webp",
    "avatarBlurhash": "y4CYN?04}l[m0R};W@*zG@a2s;I-VGo[xG-.#:58^OEPOE~j0N-.Khz?P59I04~S$M0k~8Ibt3nNE2xu=_ERt2i_xnD+I;^$ES%KnR",
    "avatarColor": null,
    "isAdmin": false,
    "isModerator": true,
    "isBot": false,
    "isLocked": false,
    "isCat": false,
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
    "driveCapacityOverrideMb": null,
    "url": null,
    "uri": null,
    "movedToUri": null,
    "alsoKnownAs": null,
    "createdAt": "2023-07-14T23:00:50.901Z",
    "updatedAt": "2023-08-20T22:49:43.951Z",
    "lastFetchedAt": null,
    "bannerUrl": "https://cdn.derg.social/calckey/d95e1533-9135-4595-b56f-da6736b3988c.jpeg",
    "bannerBlurhash": "y78EVjzA0KG^Q8pIOZD4PpxtzolUVE$%I=Vsx]oenNkrRi.8rqRPTKVrjsT08_Xn%MrWT0M|r=%MV?R+bbV@tQWWkWoeVsg4WqVsxu",
    "bannerColor": null,
    "isSilenced": false,
    "isSuspended": false,
    "description": "A 24 year old 👨🏻‍💻 Software Engineer with a particular love for dragons :therian:. Behind the Bar @ Furmeet Bern. Administrator of derg.social. Pronouns are he/him.\\n\\nBanner by @Skulblaka@swiss.social\\nProfile Picture by @Rudzik@meow.social\\nRef Sheet by @FireHyena\\nSuit by #LupeSuits",
    "location": "Bern, Switzerland",
    "birthday": "1999-06-23",
    "lang": "en",
    "fields": [
        {
            "name": "Website",
            "value": "https://bad-dragon.ch",
            "verified": true
        },
        {
            "name": "GitHub",
            "value": "https://github.com/nilathedragon",
            "verified": false
        },
        {
            "name": "Furmeet Bern",
            "value": "https://baerenhoehle.co",
            "verified": false
        },
        {
            "name": "Ko-Fi",
            "value": "https://ko-fi.com/nilathedragon",
            "verified": false
        }
    ],
    "followersCount": 101,
    "followingCount": 56,
    "notesCount": 290,
    "pinnedNoteIds": [
        "9hathflttpzd12j0"
    ],
    "pinnedNotes": [
        {
            "id": "9hathflttpzd12j0",
            "createdAt": "2023-07-17T19:22:40.577Z",
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
            "text": "Hi, I am Nila (the Dragon) 👋. I am 24 years old, located in Switzerland and I do be a dragon! :verified_dragon: \\n\\nIRL, I am a **Software Engineer** 👨🏻‍💻 working in climate tech / green energy ⚡️. We explore how we can balance grid [production and demand](https://www.iea.org/energy-system/energy-efficiency-and-demand/demand-response) or easier said:  How to **use and store** energy when it's available and **preserve and release** energy when production is low.\\n\\nIn my spare time, I engage in the local Furry community 🐉 where I am currently running the regular [Furmeet in Bern, Switzerland](https://baerenhoehle.co). Other than that, I am working on my own projects like [Go-Mojito](https://go-mojito.infinytum.co), a web framework for Golang :golang: as well as running a self-hosted Kubernetes cluster.\\n\\nLast but not least, I operate [derg.social](https://derg.social), a [Calckey](https://calckey.org/) :calckey: instance primarily for dragons and also the swiss furry fandom. If that sounds interesting to you, [we'd be glad to have you!](https://calckey.org/docs/en/account-migration/)\\n\\nPicture by @Skulblaka@swiss.social, Suit by #LupeSuits, Ref Sheet by @FireHyena  #furry #dragon #dragons #developer #switzerland #furryfediverse #introduction #introductions #introductionpost",
            "cw": null,
            "visibility": "public",
            "renoteCount": 7,
            "repliesCount": 2,
            "reactions": {
                "⭐": 28,
                ":dragnstar@.:": 1,
                ":verified_dragon@.:": 3
            },
            "reactionEmojis": [
                {
                    "name": "dragnstar@.",
                    "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
                    "width": 128,
                    "height": 128
                },
                {
                    "name": "verified_dragon@.",
                    "url": "https://cdn.derg.social/calckey/7227227c-8b87-4f9a-b484-b72a3ff84810.png",
                    "width": 230,
                    "height": 230
                }
            ],
            "emojis": [
                {
                    "name": "verified_dragon",
                    "url": "https://cdn.derg.social/calckey/7227227c-8b87-4f9a-b484-b72a3ff84810.png",
                    "width": 230,
                    "height": 230
                },
                {
                    "name": "golang",
                    "url": "https://cdn.derg.social/calckey/webpublic-e9a41660-9270-43cb-b50e-9c9650282769.webp",
                    "width": 128,
                    "height": 128
                },
                {
                    "name": "calckey",
                    "url": "https://cdn.derg.social/calckey/42ec32e8-db47-44cf-a780-e0a367f8d143.png",
                    "width": 300,
                    "height": 300
                },
                {
                    "name": "dragnstar@.",
                    "url": "https://cdn.derg.social/calckey/739d6bd3-abbf-42ac-963d-6ae3e0d60c08.png",
                    "width": 128,
                    "height": 128
                },
                {
                    "name": "verified_dragon@.",
                    "url": "https://cdn.derg.social/calckey/7227227c-8b87-4f9a-b484-b72a3ff84810.png",
                    "width": 230,
                    "height": 230
                }
            ],
            "tags": [
                "lupesuits",
                "furry",
                "dragon",
                "dragons",
                "developer",
                "switzerland",
                "furryfediverse",
                "introduction",
                "introductions",
                "introductionpost"
            ],
            "fileIds": [
                "9h7pdpbi3z",
                "9haem9urw7a4gwj1"
            ],
            "files": [
                {
                    "id": "9h7pdpbi3z",
                    "createdAt": "2023-07-15T15:04:29.550Z",
                    "name": "1500x500.jpeg",
                    "type": "image/jpeg",
                    "md5": "28e1afd23ba5f22650dfabf0faa70fdf",
                    "size": 94294,
                    "isSensitive": false,
                    "blurhash": "y78EVjzA0KG^Q8pIOZD4PpxtzolUVE$%I=Vsx]oenNkrRi.8rqRPTKVrjsT08_Xn%MrWT0M|r=%MV?R+bbV@tQWWkWoeVsg4WqVsxu",
                    "properties": {
                        "width": 1500,
                        "height": 500
                    },
                    "url": "https://cdn.derg.social/calckey/d95e1533-9135-4595-b56f-da6736b3988c.jpeg",
                    "thumbnailUrl": "https://cdn.derg.social/calckey/thumbnail-bab44a33-4d41-4c96-9bae-4bd5445282f2.webp",
                    "comment": null,
                    "folderId": null,
                    "folder": null,
                    "userId": null,
                    "user": null
                },
                {
                    "id": "9haem9urw7a4gwj1",
                    "createdAt": "2023-07-17T12:26:32.163Z",
                    "name": "Nila Dragon Refsheet.webp",
                    "type": "image/png",
                    "md5": "24332072b934ec93a8948324a84298e8",
                    "size": 1971972,
                    "isSensitive": false,
                    "blurhash": "yHF~nTmsBI9cUwxlIS.ToXI9IX%2D%oz4nN2Vgout$Rot6%jt8act2RisEawNF%dn|jdV[aiaknrWGRjk9odt7f*obt4V[WCRkWCk9",
                    "properties": {
                        "width": 2047,
                        "height": 606
                    },
                    "url": "https://cdn.derg.social/calckey/5e134f90-2283-4e48-b6aa-515b3d1b0f5e.png",
                    "thumbnailUrl": "https://cdn.derg.social/calckey/thumbnail-1d88e8cf-f398-4168-92b4-0ad60201d467.webp",
                    "comment": "Dragon Reference Sheet for Nila The Dragon.",
                    "folderId": "9hgpvzklckgqflgf",
                    "folder": null,
                    "userId": null,
                    "user": null
                }
            ],
            "replyId": null,
            "renoteId": null,
            "mentions": [
                "9h7kcnp037",
                "9h8ko5vvdo"
            ]
        }
    ]
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(UserModel.self, from: jsonData)
    }
    
    public func displayName() -> String {
        self.name ?? self.username ?? "<no name>"
    }
    
    public func renderedDisplayName() -> MFMRender {
        let rootNode = Tokenizer.username.tokenize(self.displayName())
        return mfmRender(rootNode, emojis: self.emojis ?? [])
    }
    
    public func userName() -> String {
        self.username ?? "<no username>"
    }
    
}

extension UserModel? {
    
    public func displayName() -> String {
        self?.displayName() ?? "<nil user>"
    }
    
    public func renderedDisplayName() -> MFMRender {
        let rootNode = Tokenizer.username.tokenize(self.displayName())
        return mfmRender(rootNode, emojis: self?.emojis ?? [], plaintextWordlets: 4)
    }
    
    public func userName() -> String {
        self?.userName() ?? "<nil user>"
    }
    
}
