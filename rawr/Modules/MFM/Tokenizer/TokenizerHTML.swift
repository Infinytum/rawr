//
//  TokenizerHTML.swift
//  rawr.
//
//  Created by Nila on 19.11.2023.
//

import Foundation

extension Tokenizer {
    
    static var htmlModule: TokenizerModule = TokenizerModule { text in
        text
    } probe: { session in
        session.scanner.probe("<")
    } tokenize: { session, token in
        /// Record current position as checkpoint
        session.checkpoint()
        
        /// Check whether this is an actual container tag or just a random <
        guard let tag = session.scanner.scanUpToCharacters(from: CharacterSet(charactersIn: " >")), session.scanner.scanString(">") != nil else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        /// Check for closing tag
        guard tag.range(of: "^/", options: .regularExpression) == nil else {
            guard let expectedNodeType = containerTagToNodeType(tag: String(tag.dropFirst())) else { return false }
            if session.currentNode.type != expectedNodeType {
                print("TokenizerHTML: Found unknown closing container tag \(tag.dropFirst()), skipping")
                return false
            }
            session.currentNode = session.currentNode.parentNode ?? session.rootNode
            return true
        }
        
        /// We are opening a new container, create appropriate MFMContainer and assign currentNode
        switch (containerTagToNodeType(tag: tag)) {
        case .center:
            let newNode = MFMNode(session.currentNode, container: .center)
            session.currentNode.addChild(newNode)
            session.currentNode = newNode
        case .italic:
            let newNode = MFMNode(session.currentNode, container: .italic)
            session.currentNode.addChild(newNode)
            session.currentNode = newNode
        case .small:
            let newNode = MFMNode(session.currentNode, container: .small)
            session.currentNode.addChild(newNode)
            session.currentNode = newNode
        default:
            print("TokenizerHTML: Found unknown container \(tag), skipping")
            return false
        }
        return true
    }
    
}

fileprivate func containerTagToNodeType(tag: String) -> MFMNodeType? {
    switch (tag.lowercased()) {
    case "center":
        return .center
    case "i":
        return .italic
    case "small":
        return .small
    default:
        return nil
    }
}
