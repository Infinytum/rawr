//
//  TokenizerMention.swift
//  rawr.
//
//  Created by Nila on 15.11.2023.
//

import Foundation

extension Tokenizer {
    
    static var mentionModule: TokenizerModule = TokenizerModule { text in
        text
    } probe: { session in
        session.scanner.probe("@")
    } tokenize: { session, token in
        /// Record current position as checkpoint
        session.checkpoint()
        
        /// Check if this is an actual container or just some random @
        guard let username = session.scanner.scanCharacters(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "@."))) else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        /// We found something that looks like a username, this is considered a mention.
        session.currentNode.addChild(MFMNode(session.currentNode, mention: username))
        return true
    }
    
}
