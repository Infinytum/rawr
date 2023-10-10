//
//  MetaModel.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import Foundation
import MisskeyKit

public extension MetaModel {
    
    /// Get the URL for any reaction that is present on this instance
    func emojiUrlForReaction(name: String) -> String? {
        guard let emojis = self.emojis else {
            return nil
        }
        
        guard let foundEmoji = emojis.filter({ emoji in
            return ":" + (emoji.name ?? "") + ":" == name
        }).first else {
            return nil
        }
        
        return foundEmoji.url ?? nil
    }
    
    func getIconUrl() -> String? {
        let iconUrl = self.iconUrl ?? ""
        if iconUrl == "" {
            return (self.uri ?? "") + "/favicon.ico"
        }
        return iconUrl
    }
}
