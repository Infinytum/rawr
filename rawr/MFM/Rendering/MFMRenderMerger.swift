//
//  MFMRenderMerger.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

typealias NodeSideEffect = (_ node: MFMRenderNode, _ lastNode: Bool) -> MFMRenderNode
typealias ViewSideEffect = (_ view: MFMRenderView) -> MFMRenderView

//func mfmMergeRenderResultd(_ renderResult: MFMRenderResult) -> MFMRenderNodeStack {
//    return mfmMergeRenderResultWithViewSideEffect(renderResult, viewSideEffect: defaultViewSideEffect)
//}

func mfmMergeRenderResult(_ renderResult: MFMRenderResult, nodeSideEffect: @escaping NodeSideEffect = defaultNodeSideEffect, viewSideEffect: @escaping ViewSideEffect = defaultViewSideEffect) -> MFMRenderNodeStack {
    /// Prepare render stacks to render into
    var renderStack: MFMRenderNodeStack = []
    var viewStack: MFMRenderViewStack = []
    
    /// Keep track of preferred alignment. View ending the stack (endStack = true) gets the final say.
    var alignment = Alignment.leading
    
    /// Compact MFMRenderResult into a MFMRenderNodeStack by combining multiple MFMRenderNodes into a single one, unless they require a new stack.
    for oldVNodeStack in renderResult {
        for oldNode in oldVNodeStack {
            /// If the old node enforces both the end of the current stack and a new stack:
            if oldNode.newStack && oldNode.endStack {
                /// 1. Complete the current stack
                renderStack.append(
                    nodeSideEffect(MFMRenderNode(viewStack: viewStack, newStack: false, endStack: false, alignment: alignment), false)
                )
                
                /// 2. Create a new stack and append the old node's view Stack
                viewStack = []
                viewStack.append(contentsOf: oldNode.viewStack.map(viewSideEffect))
                
                /// 3. Completet the currently created stack with the old node's alignment (sole controller here) and create a new stack
                renderStack.append(
                    nodeSideEffect(MFMRenderNode(viewStack: viewStack, newStack: false, endStack: false, alignment: oldNode.alignment), false)
                )
                viewStack = []

            /// If the old node enforces being rendered in a new stack:
            } else if oldNode.newStack {
                /// 1. Complete the current stack
                renderStack.append(
                    nodeSideEffect(MFMRenderNode(viewStack: viewStack, newStack: false, endStack: false, alignment: alignment), false)
                )
                
                /// 2. Create a new stack and append the old node's view Stack
                viewStack = []
                viewStack.append(contentsOf: oldNode.viewStack.map(viewSideEffect))
                
                /// 3. Reset alignment to default alignment since the stack has been rotated
                alignment = .leading
                
            /// If the old node enforces closing the current stack after rendering:
            } else if oldNode.endStack {
                /// 1. Set alignment to preference of closing node
                alignment = oldNode.alignment
                
                /// 2. Append the old node's view stack to the current stack and complete it
                viewStack.append(contentsOf: oldNode.viewStack.map(viewSideEffect))
                renderStack.append(
                    nodeSideEffect(MFMRenderNode(viewStack: viewStack, newStack: false, endStack: false, alignment: alignment), false)
                )
                
                /// 3. Create a new stack and reset alignment to default alignment
                viewStack = []
                alignment = .leading
            }
            
            /// If the node does not meddle with the stack, just append its view stack and move on
            if !oldNode.endStack && !oldNode.newStack {
                viewStack.append(contentsOf: oldNode.viewStack.map(viewSideEffect))
            }
        }
    }
    
    /// Complete the final stack by appending to the renderStack
    renderStack.append(
        nodeSideEffect(MFMRenderNode(viewStack: viewStack, newStack: false, endStack: false, alignment: alignment), true)
    )
    return renderStack
}

fileprivate func defaultNodeSideEffect(_ node: MFMRenderNode, _ lastNode: Bool) -> MFMRenderNode {
    return node
}

fileprivate func defaultViewSideEffect(_ view: MFMRenderView) -> MFMRenderView {
    return view
}
