//
//  MFMNode.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation

protocol MFMNodeProtocol {
    var type: MFMNodeType { get }
    var value: String? { get }
    var children: [MFMNodeProtocol] { get set }
    var parentNode: MFMNodeProtocol? { get }
    
    func addChild(_ child: MFMNodeProtocol)
}

class MFMNode: MFMNodeProtocol {
    let type: MFMNodeType
    var children: [MFMNodeProtocol] = []
    
    var value: String?
    var parentNode: MFMNodeProtocol?
    
    init() {
        self.type = .root
        self.value = nil
        self.parentNode = self
        self.children = []
    }
    
    init(_ parentNode: MFMNodeProtocol, plaintext: String) {
        self.value = plaintext
        self.type = .plaintext
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, mention: String) {
        self.value = mention
        self.type = .mention
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, hashtag: String) {
        self.value = hashtag
        self.type = .hashtag
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, modifier: String) {
        self.value = modifier
        self.type = .modifier
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, emoji: String) {
        self.value = emoji
        self.type = .emoji
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, bold: String) {
        self.value = nil
        self.type = .bold
        self.children = [MFMNode(self, plaintext: bold)]
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, container: MFMNodeType) {
        self.value = nil
        self.type = container
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, url: String, displayText: String) {
        self.value = url
        self.type = .url
        self.children = [MFMNode(self, plaintext: displayText)]
        self.parentNode = parentNode
    }
    
    init(_ parentNode: MFMNodeProtocol, type: MFMNodeType, value: String?, children: [MFMNodeProtocol]) {
        self.value = value
        self.type = type
        self.parentNode = parentNode
        self.children = children
    }
    
    func addChild(_ child: MFMNodeProtocol) {
        guard let childBefore = self.children.last else {
            self.children.append(child)
            return
        }
        
        if childBefore.type == child.type {
            var combinedChildren: [MFMNodeProtocol] = []
            combinedChildren.append(contentsOf: childBefore.children)
            combinedChildren.append(contentsOf: child.children)
            let combinedNode = MFMNode(self, type: child.type, value: childBefore.value.append(maybeString: child.value), children: combinedChildren)
            self.children.removeLast()
            self.children.append(combinedNode)
        } else {
            self.children.append(child)
        }
    }
}
