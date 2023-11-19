//
//  TokenizerMFMModifier.swift
//  rawr.
//
//  Created by Nila on 19.11.2023.
//

import Foundation

extension Tokenizer {
    
    static var mfmModifierModule: TokenizerModule = TokenizerModule { text in
        text
    } probe: { session in
        session.scanner.probe("$[") ?? session.scanner.probe("]")
    } tokenize: { session, token in
        /// Record current position as checkpoint
        session.checkpoint()
        
        /// Check if we are handling an opener or a closer
        if token == "]" {
            /// Check if this is actually closing a container or just a random ]
            guard session.currentNode.type == .modifier else {
                session.restore()
                session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
                return true
            }
            
            session.currentNode = session.currentNode.parentNode ?? session.rootNode
            return true
        }
        
        /// Check if this is an actual container or just some random $[
        guard let scannedModifier = session.scanner.scanUpToCharacters(from: CharacterSet.whitespaces), session.scanner.scanString(" ") != nil else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        /// Modifier found, new container node needed!
        let newNode = MFMNode(session.currentNode, modifier: scannedModifier)
        session.currentNode.addChild(newNode)
        session.currentNode = newNode
        return true
    }
    
}
