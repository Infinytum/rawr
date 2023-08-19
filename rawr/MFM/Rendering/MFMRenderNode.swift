//
//  MFMRenderNode.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

/// Represent a stack of different results produced by multiple nodes
public typealias MFMRenderResult = [MFMRenderNodeStack]

/// Represent an stack of different results produced by one node
public typealias MFMRenderNodeStack = [MFMRenderNode]

/// Represents one result produced by a node
public struct MFMRenderNode {
    /// Produced SwiftUI views during rendering
    let viewStack: MFMRenderViewStack
    
    /// Whether to render the products in a new, separate stack
    let newStack: Bool
    
    /// Whether to close the current stack after rendering the products in the current stack.
    let endStack: Bool
    
    /// Aligment preference of the products
    let alignment: Alignment
}

/// Represents an array of rendered SwiftUI views
typealias MFMRenderViewStack = [MFMRenderView]

/// Make any view identifiable and ensures render output can be used in SwiftUI directly
public struct MFMRenderView: Identifiable, View {
    public let id: UUID = UUID()
    @ViewBuilder var view: any View
    
    public var body: some View {
        AnyView(view)
    }
}
