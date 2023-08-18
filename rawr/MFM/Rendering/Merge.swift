//
//  Merge.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

func mergeMFMChildStacks(_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        return view
    }
}

func mergeMFMChildStacksWithViewSideEffect(_ renderedChildren: [[RenderedNode]], sideEffect: @escaping (_ view: IdentifiableView) -> IdentifiableView) -> [RenderedNode] {
    var viewStack: [RenderedNode] = []
    var stack: [IdentifiableView] = []
    var alignment = Alignment.leading
    
    for child in renderedChildren {
        for view in child {
            if view.newStack && view.endStack {
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                stack.append(contentsOf: view.viewStack.map(sideEffect))
                alignment = view.alignment
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                alignment = .leading
            } else if view.newStack {
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                stack.append(contentsOf: view.viewStack.map(sideEffect))
                alignment = view.alignment
            } else if view.endStack {
                alignment = view.alignment
                stack.append(contentsOf: view.viewStack.map(sideEffect))
                viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
                stack = []
                alignment = .leading
            }
            if !view.endStack && !view.newStack {
                stack.append(contentsOf: view.viewStack.map(sideEffect))
            }
        }
    }
    viewStack.append(RenderedNode(viewStack: stack, newStack: false, endStack: false, alignment: alignment))
    return viewStack
}
