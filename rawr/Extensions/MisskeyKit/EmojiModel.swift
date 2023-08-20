//
//  EmojiModel.swift
//  rawr.
//
//  Created by Nila on 15.08.2023.
//

import Foundation
import MisskeyKit

extension EmojiModel: Identifiable {}
extension DefaultEmojiModel: Identifiable {
    public var id: String {
        get {
            return self.name!
        }
    }
}

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
