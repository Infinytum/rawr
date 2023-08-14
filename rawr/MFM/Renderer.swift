//
//  Renderer.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation
import WrappingHStack
import SwiftUI

func renderMFM(_ node: MFMNodeProtocol) -> any View {
    guard node.type == .root else {
        return VStack { }
    }
    
    var renderedChildren: [any View] = []
    for child in node.children {
        renderedChildren.append(contentsOf: renderMFMNode(child))
    }
    
    return WrappingHStack(renderedChildren, spacing:.constant(0)) {
        AnyView($0)
    }
}

func renderMFMNode(_ node: MFMNodeProtocol) -> [any View] {
    var views: [any View] = []
    var renderedChildren: [any View] = []
    for child in node.children {
        renderedChildren.append(contentsOf: renderMFMNode(child))
    }
    
    switch node.type {
    case .root:
        return [VStack{}]
    case .plaintext:
        for split in (node.value ?? "").split(separator: "") {
            views.append(split == "\n" ? NewLine() : Text(split))
        }
        return views
    case .mention:
        return [Text(node.value ?? "")
            .foregroundStyle(.blue)]
    case .hashtag:
        views.append(Text("#").foregroundStyle(.blue))
        for split in (node.value ?? "").split(separator: "") {
            views.append(Text(split).foregroundStyle(.blue))
        }
        return views
    case .emoji:
        return [RemoteImage("https://cdn.derg.social/assets/icon.png").frame(width: 30, height: 30)]
    case .modifier:
        for split in "MODIFIERS UNSUPPORTED".split(separator: "") {
            views.append(split == "\n" ? NewLine() : Text(split))
        }
        return views
    case .small:
        for split in (node.value ?? "").split(separator: "") {
            views.append(Text(split).font(.system(size: 14)))
        }
        return views
    case .center:
        return [
            NewLine(),
            WrappingHStack(renderedChildren, alignment: .center, spacing:.constant(0)) {
                AnyView($0)
            },
            NewLine()
        ]
    }
}

#Preview {
    VStack {
        Spacer()
        AnyView(renderMFM(tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn:\n https://www.example.com")))
        Spacer()
    }
}
