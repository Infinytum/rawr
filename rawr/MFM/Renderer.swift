//
//  Renderer.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation
import MisskeyKit
import WrappingHStack
import SwiftUI
import SwiftUIFlow

struct RenderedNode {
    let viewStack: [any View]
    let newStack: Bool
    let endStack: Bool
    let alignment: Alignment
}

func renderMFM(_ node: MFMNodeProtocol, emojis: [EmojiModel] = []) -> [any View] {
    let renderedChildren = node.children.map { child in
        renderMFMNode(child, emojis: emojis)
    }
    
    var viewStack: [RenderedNode] = []
    var stack: [any View] = []
    var alignment = Alignment.leading
    for child in renderedChildren {
        for view in child {
            if view.newStack && view.endStack {
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                stack.append(contentsOf: view.viewStack)
                alignment = view.alignment
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                alignment = .leading
            } else if view.newStack {
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                stack.append(contentsOf: view.viewStack)
                alignment = view.alignment
            } else if view.endStack {
                alignment = view.alignment
                stack.append(contentsOf: view.viewStack)
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                alignment = .leading
            }
            if !view.endStack && !view.newStack {
                stack.append(contentsOf: view.viewStack)
            }
        }
    }
    viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
    
    return viewStack.map { childStack in
        return WrappingHStack(alignment: childStack.alignment, horizontalSpacing: 0, verticalSpacing: 1) {
            ForEach(Array(childStack.viewStack.enumerated()), id: \.offset) { _, view in
                AnyView(view)
            }
        }
    }
}

func renderMFMNode(_ node: MFMNodeProtocol, emojis: [EmojiModel]) -> [RenderedNode] {
    let renderedChildrenStacks = node.children.map { child in
        renderMFMNode(child, emojis: emojis)
    }
    
    var renderedNodes: [RenderedNode] = []
    var views: [any View] = []
    
    switch node.type {
    case .root:
        return []
    case .plaintext:
        let message = node.value ?? ""
        let lines = message.split(whereSeparator: \.isNewline)

        var beginsWithBreak = message.first?.isNewline ?? false
        var count = 0
        for line in lines {
            for split in line.split(separator: " ") {
                for subSplit in String(split).split(every: 15) {
                    views.append(Text(subSplit))
                }
                views.append(Text(" "))
            }
            if !views.isEmpty && (message.last ?? Character.init(".")) != " " {
                views.removeLast()
            }
            renderedNodes.append(RenderedNode(viewStack: views, newStack: beginsWithBreak, endStack: lines.count > 1 && count < lines.count-1, alignment: .leading))
            views = []
            count += 1
            beginsWithBreak = false
        }
        return renderedNodes
    case .mention:
        views.append(Text("@" + (node.value ?? "")).foregroundStyle(.orange))
        views.append(Text(" "))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .hashtag:
        views.append(Text("#" + (node.value ?? "")).foregroundStyle(.blue))
        views.append(Text(" "))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .emoji:
        views.append(Emoji(name: node.value ?? "", emojis: emojis).frame(width: 30, height: 30) )
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .modifier:
        views.append(Text("MODIFIERS UNSUPPORTED"))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .small:
        for split in (node.value ?? "").split(separator: "") {
            views.append(Text(split).font(.system(size: 14)))
        }
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .center:
        var viewStack: [RenderedNode] = []
        var stack: [any View] = []
        
        var newStack = true
        for child in renderedChildrenStacks {
            for view in child {
                if view.newStack {
                    viewStack.append(RenderedNode(viewStack: stack, newStack: newStack, endStack: false, alignment: .center))
                    stack = []
                    stack.append(contentsOf: view.viewStack)
                    newStack = false
                } else if view.endStack {
                    stack.append(contentsOf: view.viewStack)
                    viewStack.append(RenderedNode(viewStack: stack, newStack: newStack, endStack: false, alignment: .center))
                    stack = []
                    newStack = false
                } else {
                    stack.append(contentsOf: view.viewStack)
                }
            }
        }
        viewStack.append(RenderedNode(viewStack: stack, newStack: newStack, endStack: true, alignment: .center))
        return viewStack
    }
}


// Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn:\n https://www.example.com
// Hello @user how are you doing this is a very long text I hope it will wrap.\nYay it did. Great so far! Nice walk-in rack :drgn: <center> This text should be centered</center> And this shouldn't
#Preview {
    VStack {
        Spacer()
        ForEach(Array(renderMFM(tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn:\nhttps://www.example.com")).enumerated()), id: \.offset) { _, view in
            AnyView(view)
        }
        Spacer()
    }.border(.brown).environmentObject(ViewContext())
}
