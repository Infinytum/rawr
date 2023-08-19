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

struct IdentifiableView: Identifiable {
    var id: UUID = UUID()
    let view: any View
}

struct MFMRender {
    let context: RendererContext
    let renderedNote: [IdentifiableView]
}

class RendererContext {
    var hashtagHandler: ((_ hashtag: String) -> Void)?
    
    // Fire an event when a hashtag has been tapped by the user
    fileprivate func tapHashtag(_ hashtag: String) {
        guard let hashtagHandler = hashtagHandler else {
            return
        }
        hashtagHandler(hashtag)
    }
    
    // Register a tap handler for hashtags inside a pre-rendered note
    func onHashtagTap(result callback: @escaping (_ hashtag: String) -> Void) {
        self.hashtagHandler = callback
    }
}

struct RenderedNode {
    let viewStack: [IdentifiableView]
    let newStack: Bool
    let endStack: Bool
    let alignment: Alignment
}

func renderMFM(_ node: MFMNodeProtocol, emojis: [EmojiModel] = []) -> MFMRender {
    let rendererContext: RendererContext = RendererContext()
    let renderedChildren = node.children.map { child in
        renderMFMNode(child, emojis: emojis, rendererContext: rendererContext)
    }
    let viewStack: [RenderedNode] = mergeMFMChildStacks(renderedChildren)
    
    return MFMRender(context: rendererContext, renderedNote: viewStack.map { childStack in
        return IdentifiableView(view: WrappingHStack(alignment: childStack.alignment, horizontalSpacing: 0, verticalSpacing: 1) {
            if childStack.viewStack.isEmpty {
                Text("")
            }
            ForEach(childStack.viewStack) { view in
                AnyView(view.view)
            }
        })
    })
}

func renderMFMNode(_ node: MFMNodeProtocol, emojis: [EmojiModel], rendererContext: RendererContext) -> [RenderedNode] {
    let renderedChildrenStacks = node.children.map { child in
        renderMFMNode(child, emojis: emojis, rendererContext: rendererContext)
    }
    
    var renderedNodes: [RenderedNode] = []
    var views: [IdentifiableView] = []
    
    switch node.type {
    case .root:
        return []
    case .plaintext:
        let message = node.value ?? ""
        let lines = message.components(separatedBy: .newlines)

        var beginsWithBreak = message.first?.isNewline ?? false
        var count = 0
        for line in lines {
            for split in line.split(separator: " ") {
                for subSplit in String(split).split(every: 15) {
                    views.append(IdentifiableView(view: Text(subSplit)))
                }
                views.append(IdentifiableView(view: Text(" ")))
            }
            renderedNodes.append(RenderedNode(viewStack: views, newStack: beginsWithBreak, endStack: lines.count > 1 && count < lines.count-1, alignment: .leading))
            views = []
            count += 1
            beginsWithBreak = false
        }
        return renderedNodes
    case .mention:
        views.append(IdentifiableView(view: Text("@" + (node.value ?? "")).foregroundStyle(.orange)))
        views.append(IdentifiableView(view: Text(" ")))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .hashtag:
        views.append(IdentifiableView(view: Text("#" + (node.value ?? "")).foregroundStyle(.blue).onTapGesture {
            rendererContext.tapHashtag(node.value ?? "")
        }))
        views.append(IdentifiableView(view: Text(" ")))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .emoji:
        views.append(IdentifiableView(view: Emoji(name: node.value ?? "", emojis: emojis).frame(width: 30, height: 30)))
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .modifier:
        return selectModifierFunction(node.value ?? "")(renderedChildrenStacks)
    case .small:
        for split in (node.value ?? "").split(separator: "") {
            views.append(IdentifiableView(view: Text(split).font(.system(size: 14))))
        }
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .center:
        var viewStack: [RenderedNode] = []
        var stack: [IdentifiableView] = []
        
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
    case .url:
        guard let url = node.value, let displayName = renderedChildrenStacks.first else {
            return []
        }
        
        for node in displayName {
            for view in node.viewStack {
                views.append(IdentifiableView(view: view.view.foregroundColor(.blue).onTapGesture {
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                }))
            }
        }
        
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    case .bold:
        guard let boldText = renderedChildrenStacks.first else {
            return []
        }
        
        for node in boldText {
            for view in node.viewStack {
                views.append(IdentifiableView(view: view.view.fontWeight(.bold)))
            }
        }
        
        return [RenderedNode(viewStack: views, newStack: false, endStack: false, alignment: .leading)]
    }
}


// Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn:\n https://www.example.com
// Hello @user how are you doing this is a very long text I hope it will wrap.\nYay it did. Great so far! Nice walk-in rack :drgn: <center> This text should be centered</center> And this shouldn't
#Preview {
    VStack {
        Spacer()
        ForEach(renderMFM(tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered **test** $[tada $[x2 $[sparkle gay]]]</center> **test** #test_2023. Visit:asd :drgn:\nhttps://www.example.com\n $[x4 $[bg.color=000000 $[fg.color=00ff00 *hacker voice* I'm in]]]")).renderedNote) { view in
            AnyView(view.view).border(.gray)
        }
        Spacer()
    }.border(.brown).environmentObject(ViewContext())
}
