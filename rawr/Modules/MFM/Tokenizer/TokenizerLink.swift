//
//  TokenizerLink.swift
//  rawr.
//
//  Created by Nila on 19.11.2023.
//

import Foundation
import RegexBuilder

// Used to find plain URLs (https://...) instead of markdown URLs ([Name](https://...))
fileprivate let plainUrlRegex = Regex {
    Capture {
        Optionally {
            "]("
        }
        Capture {
            .url()
        }
    }
}

extension Tokenizer {
    
    static var linkModule = TokenizerModule { text in
        text.replacing(plainUrlRegex) { match in
            if match.output.0.starts(with: "](") {
                return match.output.0
            }
            var displayText = match.output.0
            displayText.replace(match.output.2.absoluteString, with: "[\(match.output.2)](\(match.output.2))")
            return displayText
        }
    } probe: { session in
        session.scanner.probe("[")
    } tokenize: { session, token in
        /// Record current position as checkpoint
        session.checkpoint()
        
        /// Check if this is an actual container or just some random [
        guard let displayText = session.scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "]")), session.scanner.scanString("](") != nil else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        guard let url = session.scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ")")), session.scanner.scanString(")") != nil else {
            session.restore()
            session.currentNode.addChild(MFMNode(session.currentNode, plaintext: token))
            return true
        }
        
        session.currentNode.addChild(MFMNode(session.currentNode, url: url, displayText: displayText))
        return true
    }
    
}
