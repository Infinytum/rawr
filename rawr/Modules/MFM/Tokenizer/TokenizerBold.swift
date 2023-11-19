//
//  TokenizerBold.swift
//  rawr.
//
//  Created by Nila on 19.11.2023.
//

import Foundation

extension Tokenizer {
    
    static var boldModule: TokenizerModule = TokenizerModule { text in
        text
    } probe: { session in
        session.scanner.probe("**")
    } tokenize: { session, token in
        /// Check if we are closing an existing bold modifier container
        guard session.currentNode.type != .bold else {
            session.currentNode = session.currentNode.parentNode ?? session.rootNode
            return true
        }
        
        /// Modifier found, new container node needed!
        let newNode = MFMNode(session.currentNode, container: .bold)
        session.currentNode.addChild(newNode)
        session.currentNode = newNode
        return true
    }
    
}
