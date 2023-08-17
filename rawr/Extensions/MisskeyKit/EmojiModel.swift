//
//  EmojiModel.swift
//  rawr.
//
//  Created by Nila on 15.08.2023.
//

import Foundation
import MisskeyKit

public extension [EmojiModel] {
    func urlForEmoji(_ name: String) -> String? {
        let foundEmoji = self.first { emoji in
            ":" + (emoji.name ?? "") + ":" == name || (emoji.name ?? "") == name
        }
        guard let url = foundEmoji?.url else {
            return nil
        }
        return url
    }
}
