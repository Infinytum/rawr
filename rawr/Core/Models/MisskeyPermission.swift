//
//  MisskeyPermission.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import Foundation

/// Pulled from https://git.joinfirefish.org/firefish/firefish/-/blob/develop/packages/backend/src/server/api/mastodon/endpoints/auth.ts
enum MisskeyPermission: String, CaseIterable {
    case readAccount = "read:account"
    case readDrive = "read:drive"
    case readBlocks = "read:blocks"
    case readFavorites = "read:favorites"
    case readFollowing = "read:following"
    case readMessaging = "read:messaging"
    case readMutes = "read:mutes"
    case readNotifications = "read:notifications"
    case readReactions = "read:reactions"
    case readPages = "read:pages"
    case readPageLikes = "read:page-likes"
    case readUserGroups = "read:user-groups"
    case readChannels = "read:channels"
    case readGallery = "read:gallery"
    case readGalleryLikes = "read:gallery-likes"
    
    case writeAccount = "write:account"
    case writeDrive = "write:drive"
    case writeBlocks = "write:blocks"
    case writeFavorites = "write:favorites"
    case writeFollowing = "write:following"
    case writeMessaging = "write:messaging"
    case writeMutes = "write:mutes"
    case writeNotes = "write:notes"
    case writeNotifications = "write:notifications"
    case writeReactions = "write:reactions"
    case writeVotes = "write:votes"
    case writePages = "write:pages"
    case writePageLikes = "write:page-likes"
    case writeUserGroups = "write:user-groups"
    case writeChannels = "write:channels"
    case writeGallery = "write:gallery"
    case writeGalleryLikes = "write:gallery-likes"
    
    static var allPermissions: [String] {
        return MisskeyPermission.allCases.map { $0.rawValue }
    }
}
