//
//  Tokenizer.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation
import SwiftUI

enum TokenType {
    case plainText
    case containerStart(tag: String)
    case containerEnd(tag: String)
    case mention
    case modifier
    case url
}

struct Token {
    let type: TokenType
    let value: String
}

func tokenize(_ input: String) -> MFMNodeProtocol {
    let scanner = Scanner(string: input)
    scanner.charactersToBeSkipped = nil
    
    let rootNode = MFMNode()
    var currentNode: MFMNodeProtocol = rootNode

    while !scanner.isAtEnd {
        if let text = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "<$@]#:")) {
            currentNode.addChild(MFMNode(currentNode, plaintext: text))
        }
        
        // MARK: Search for <> containers
        if let token = scanner.scanString("<") {
            let startLocation = scanner.currentIndex
            
            /// Check whether this is an actual container tag or just a random <
            guard let tag = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ">")), scanner.scanString(">") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            /// Check for closing tag
            guard tag.range(of: "^/", options: .regularExpression) == nil else {
                guard let expectedNodeType = containerTagToNodeType(tag: String(tag.dropFirst())) else { continue }
                if currentNode.type != expectedNodeType {
                    print("Found unknown closing container tag \(tag.dropFirst()), skipping")
                    continue
                }
                currentNode = currentNode.parentNode ?? rootNode
                continue
            }
            
            /// We are opening a new container, create appropriate MFMContainer and assign currentNode
            switch (containerTagToNodeType(tag: tag)) {
            case .center:
                let newNode = MFMNode(currentNode, container: .center)
                currentNode.addChild(newNode)
                currentNode = newNode
            case .small:
                let newNode = MFMNode(currentNode, container: .small)
                currentNode.addChild(newNode)
                currentNode = newNode
            default:
                print("Found unknown container \(tag), skipping")
                continue
            }

        // MARK: Search for beginning of $[] modifiers
        } else if let token = scanner.scanString("$[") {
            let startLocation = scanner.currentIndex

            /// Check if this is an actual container or just some random $[
            guard let scannedModifier = scanner.scanUpToCharacters(from: CharacterSet.whitespaces), scanner.scanString(" ") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            /// Modifier found, new container node needed!
            let newNode = MFMNode(currentNode, modifier: scannedModifier)
            currentNode.addChild(newNode)
            currentNode = newNode
            continue

        // MARK: Search for end of $[] modifiers
        } else if let token = scanner.scanString("]") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random $[
            guard currentNode.type == .modifier else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode = currentNode.parentNode ?? rootNode
            continue

        // MARK: Search for @Mentions
        } else if let token = scanner.scanString("@") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random @
            guard let username = scanner.scanUpToCharacters(from: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "!"))) else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode.addChild(MFMNode(currentNode, mention: username))
            continue
            
        // MARK: Search for #Hashtags
        } else if let token = scanner.scanString("#") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random #
            guard let hashtag = scanner.scanCharacters(from: CharacterSet.alphanumerics) else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode.addChild(MFMNode(currentNode, hashtag: hashtag))
            continue
            
        // MARK: Search for :emojis:
        } else if let token = scanner.scanString(":") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random #
            guard let emoji = scanner.scanCharacters(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))), scanner.scanString(":") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode.addChild(MFMNode(currentNode, emoji: emoji))
            continue
        }
        
        if let text = scanner.scanCharacters(from: CharacterSet(charactersIn: "$")) {
            currentNode.addChild(MFMNode(currentNode, plaintext: text))
        }
    }
    return rootNode
}

func containerTagToNodeType(tag: String) -> MFMNodeType? {
    switch (tag.lowercased()) {
    case "center":
        return .center
    case "small":
        return .small
    default:
        return nil
    }
}

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Visualizer(rootNode: tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn: https://www.example.com"))
    }
}

