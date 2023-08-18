//
//  NodeType.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation

enum MFMNodeType: String {
    
    // MARK: Root. Just root.
    
    /// The root node, not part of the text
    case root = "root"
    
    // MARK: Plain Content
    
    /// Text that should be rendered as is. The parent node can influence the final render of plaintext.
    case plaintext = "plain"
    
    /// A mention of a local or remote user (E.g. @nila or @nila@derg.social).
    case mention = "mention"
    
    /// A #hashtag. I doubt this one needs an introduction
    case hashtag = "hashtag"
    
    /// A custom emoji (E.g. :drgn:)
    case emoji = "emoji"
    
    // MARK: Text Containers (Affects rendering of child nodes but have no content value themselves)
 
    /// A text container for custom misskey modifiers (E.G. $[x2 text])
    case modifier = "modifier"
    
    /// A text container that forces child nodes to be rendered with a smaller font
    case small = "small"
    
    /// A text container that forces child nodes to be center aligned
    case center = "center"
    
    /// A text container that has a display text but is also an URL tap target
    case url = "url"
    
}
