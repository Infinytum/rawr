//
//  Tokenizer.swift
//  rawr.
//
//  Created by Nila on 15.11.2023.
//

import Foundation

class Tokenizer {
    
    // Ideal for rendering notes, all modules are enabled.
    static let note = Tokenizer([boldModule, emojiModule, hashtagModule, htmlModule, linkModule, mentionModule, mfmModifierModule])
    
    // Ideal for rendering usernames. Emojis & Bold are enabled.
    static let username = Tokenizer([boldModule, emojiModule])
    
    // A list of modules that will be used for tokenizing any given text
    let modules: [TokenizerModule];
    
    init(_ modules: [TokenizerModule]) {
        self.modules = modules
    }
    
    func tokenize(_ text: String) -> MFMNodeProtocol {
        var preparedText = text
        for module in self.modules {
            preparedText = module.prepare(preparedText)
        }
        
        let session = TokenizerSession(preparedText)
        while !session.scanner.isAtEnd {
            var ranOutOfModules = true
            for module in modules {
                guard let probedToken = module.probe(session) else {
                    continue // Not applicable, continue checking modules
                }
                if module.tokenize(session, probedToken) {
                    ranOutOfModules = false
                    break // Re-start the module chain as we have modified the currentNode
                }
                continue // Continue module chain as we have not done anything
            }
            
            // Ran out of modules, this could indicate that we are stuck.
            if ranOutOfModules {
                guard let nextChar = session.scanner.scanCharacter() else {
                    continue
                }
                session.currentNode.addChild(MFMNode(session.currentNode, plaintext: String(nextChar)))
            }
        }
        return session.rootNode
    }
}

struct TokenizerModule {
    let prepare: (_ text: String) -> String
    
    let probe: (_ tokenizer: TokenizerSession) -> String?
    
    let tokenize: (_ tokenizer: TokenizerSession, _ token: String) -> Bool
}

// TokenizerSession holds all working variables for an ongoing tokenizing session.
class TokenizerSession {
    // currentNode is the current container node in which child nodes are added.
    // This variable will change multiple times during tokenization as containers are opened and closed throughout the text.
    var currentNode: MFMNodeProtocol;
    
    // scanner is a position-keeping pointer with look-ahead capability that simplifies the process of tokenizing.
    let scanner: Scanner;
    
    // storedScannerPosition is a temporary store for a scanner position which is used in checkpoint/restore.
    var storedScannerPosition: String.Index
    
    // rootNode is the ultimate parent node of all tokenized nodes within the text. It itself has no value
    // and is not dependent on the text at all.
    let rootNode: MFMNodeProtocol;
    
    init(_ text: String) {
        self.rootNode = MFMNode()
        self.currentNode = self.rootNode
        
        self.scanner = Scanner(string: text)
        self.scanner.charactersToBeSkipped = .none
        self.storedScannerPosition = self.scanner.currentIndex
    }
    
    internal func checkpoint() {
        self.storedScannerPosition = self.scanner.currentIndex
    }
    
    internal func restore() {
        self.scanner.currentIndex = self.storedScannerPosition
    }
}
