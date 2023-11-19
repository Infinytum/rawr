//
//  TokenizerEmoji.swift
//  rawr.
//
//  Created by Nila on 19.11.2023.
//

import Foundation

extension Tokenizer {
    
    static var emojiModule: TokenizerModule = TokenizerModule { text in
        text
    } probe: { session in
        session.scanner.probe(":")
    } tokenize: { session, token in
        /// Record current position as checkpoint
        session.checkpoint()
        
        /// Check if this is an actual container or just some random #
        guard let emoji = session.scanner.scanCharacters(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))) else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        guard session.scanner.scanString(":") != nil else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        session.currentNode.addChild(MFMNode(session.currentNode, emoji: emoji))
        return true
    }
    
}
