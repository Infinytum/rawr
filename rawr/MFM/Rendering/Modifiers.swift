//
//  Modifiers.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

enum MFMModifier: String {
    case big = "x2"
    case bigger = "x3"
    case biggest = "x4"
    case fontColour = "fg.color"
    case backgroundColour = "bg.color"
}

typealias ModifierCallalble = (_ renderedChildren: [[RenderedNode]]) -> [RenderedNode]
typealias ModifierCallalbleWithValue = (_ renderedChildren: [[RenderedNode]], _ value: String?) -> [RenderedNode]

func selectModifierFunction(_ modifierText: String) -> (_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    let splitModifier = modifierText.split(separator: "=")
    let modifier = splitModifier[0]
    let value = splitModifier.count > 1 ? "\(splitModifier[1])" : nil
    
    guard let parsed = MFMModifier(rawValue: modifier.lowercased()) else {
        return applyUnsupportedModifier
    }
    
    switch parsed {
    case .big:
        return applyBigModifier
    case .bigger:
        return applyBiggerModifier
    case .biggest:
        return applyBiggestModifier
    case .fontColour:
        return modifierWrapper(value: value, inner: applyFontColour)
    case .backgroundColour:
        return modifierWrapper(value: value, inner: applyBackgroundColor)
    }
}

func modifierWrapper(value: String?, inner: @escaping ModifierCallalbleWithValue) -> ModifierCallalble {
    return { renderedChildren in
        inner(renderedChildren, value)
    }
}

func applyUnsupportedModifier(_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    print("Modifiers: Rendering unspported modifier as plain text")
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        view
    }
}

func applyBigModifier(_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        IdentifiableView(view: view.view.font(.system(size: 20)))
    }
}

func applyBiggerModifier(_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        IdentifiableView(view: view.view.font(.system(size: 24)))
    }
}

func applyBiggestModifier(_ renderedChildren: [[RenderedNode]]) -> [RenderedNode] {
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        IdentifiableView(view: view.view.font(.system(size: 28)))
    }
}


func applyFontColour(_ renderedChildren: [[RenderedNode]], value: String?) -> [RenderedNode] {
    let color = value != nil ? Color(hex: value!) : Color.primary
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        IdentifiableView(view: view.view.foregroundColor(color))
    }
}


func applyBackgroundColor(_ renderedChildren: [[RenderedNode]], value: String?) -> [RenderedNode] {
    let color = value != nil ? Color(hex: value!) : nil
    return mergeMFMChildStacksWithViewSideEffect(renderedChildren) { view in
        IdentifiableView(view: color != nil ? view.view.background(color) : view.view)
    }
}

