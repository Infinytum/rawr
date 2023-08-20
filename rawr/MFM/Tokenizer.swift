//
//  Tokenizer.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation
import SwiftUI
import RegexBuilder

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

let urlRegex = Regex {
    Capture {
        Repeat(0...2) {
            One(.any)
        }
        Capture {
            .url()
        }
    }
}

func tokenize(_ originalInput: String) -> MFMNodeProtocol {
    var input = originalInput
    
    // MARK: Replace plain URL with Markdown-formatted URLs
    input.replace(urlRegex) { match in
        if match.output.0.starts(with: "](") {
            return match.output.0
        }
        var displayText = match.output.0
        displayText.replace(match.output.2.absoluteString, with: "[\(match.output.2)](\(match.output.2))")
        return displayText
    }
    
    let scanner = Scanner(string: input)
    scanner.charactersToBeSkipped = nil
    
    let rootNode = MFMNode()
    var currentNode: MFMNodeProtocol = rootNode

    while !scanner.isAtEnd {
        if let text = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "<$@]#:[*")) {
            currentNode.addChild(MFMNode(currentNode, plaintext: text))
        }
        
        // MARK: Search for <> containers
        if let token = scanner.probe("<") {
            let startLocation = scanner.currentIndex
            
            /// Check whether this is an actual container tag or just a random <
            guard let tag = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: " >")), scanner.scanString(">") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            /// Check for closing tag
            guard tag.range(of: "^/", options: .regularExpression) == nil else {
                guard let expectedNodeType = containerTagToNodeType(tag: String(tag.dropFirst())) else { continue }
                if currentNode.type != expectedNodeType {
                    print("Tokenizer: Found unknown closing container tag \(tag.dropFirst()), skipping")
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
            case .italic:
                let newNode = MFMNode(currentNode, container: .italic)
                currentNode.addChild(newNode)
                currentNode = newNode
            case .small:
                let newNode = MFMNode(currentNode, container: .small)
                currentNode.addChild(newNode)
                currentNode = newNode
            default:
                print("Tokenizer: Found unknown container \(tag), skipping")
                continue
            }

        // MARK: Search for beginning of $[] modifiers
        } else if let token = scanner.probe("$[") {
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
        } else if let token = scanner.probe("]") {
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
        } else if let token = scanner.probe("@") {
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
        } else if let token = scanner.probe("#") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random #
            guard let hashtag = scanner.scanCharacters(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_-"))) else {
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
            guard let emoji = scanner.scanCharacters(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))) else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            guard scanner.scanString(":") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode.addChild(MFMNode(currentNode, emoji: emoji))
            continue
        // MARK: Search for Markdown-formatted URLs [Display Text](https://url.to/go#to)
        } else if let token = scanner.probe("[") {
            let startLocation = scanner.currentIndex
            
            /// Check if this is an actual container or just some random [
            guard let displayText = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "]")), scanner.scanString("](") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            guard let url = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: ")")), scanner.scanString(")") != nil else {
                scanner.currentIndex = startLocation
                currentNode.addChild(MFMNode(currentNode, plaintext: token))
                continue
            }
            
            currentNode.addChild(MFMNode(currentNode, url: url, displayText: displayText))
            continue
        // MARK: Search for Markdown-formatted **bold text**
        } else if let token = scanner.probe("**") {
            let startLocation = scanner.currentIndex
            
            // Check if we are closing an existing bold modifier container
            guard currentNode.type != .bold else {
                currentNode = currentNode.parentNode ?? rootNode
                continue
            }
            
            /// Modifier found, new container node needed!
            let newNode = MFMNode(currentNode, container: .bold)
            currentNode.addChild(newNode)
            currentNode = newNode
            continue
            
//            /// Check if this is an actual container or just some random **
//            guard let boldText = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "*")), scanner.scanString("**") != nil else {
//                scanner.currentIndex = startLocation
//                currentNode.addChild(MFMNode(currentNode, plaintext: token))
//                continue
//            }
            
//            currentNode.addChild(MFMNode(currentNode, bold: boldText))
        }
        
        if let text = scanner.scanCharacters(from: CharacterSet(charactersIn: "$")) {
            currentNode.addChild(MFMNode(currentNode, plaintext: text))
        } else if let text = scanner.scanCharacters(from: CharacterSet(charactersIn: "*")) {
            currentNode.addChild(MFMNode(currentNode, plaintext: text))
        }
    }
    return rootNode
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

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Visualizer(rootNode: tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> **test** #test_2023. Visit:asd :drgn:\nhttps://www.example.com")).scaleEffect(0.5)
    }
}

