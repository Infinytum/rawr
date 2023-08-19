//
//  MFMRenderModifier.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

public typealias MFMRenderModifierCallalble = (_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack

public func mfmRenderModifier(_ mfmModifier: MFMModifier?, value: String?) -> MFMRenderModifierCallalble {
    guard let mfmModifier = mfmModifier else {
        return applyUnsupportedModifier
    }
    
    switch mfmModifier {
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

// MARK: Modifier Implementations

/// Anything the modifier rendering system does not currently support
fileprivate func applyUnsupportedModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    print("Modifiers: Rendering unspported modifier as plain text")
    return mfmMergeRenderResult(renderedChildren)
}

/// $[x2 Big Text]
fileprivate func applyBigModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.font(.system(size: 20))
        }
    })
}

/// $[x3 Bigger Text]
fileprivate func applyBiggerModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.font(.system(size: 24))
        }
    })
}

/// $[x4 Biggest Text]
fileprivate func applyBiggestModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.font(.system(size: 28))
        }
    })
}

/// $[fg.color=ff0000 Red Text]
fileprivate func applyFontColour(_ renderedChildren: MFMRenderResult, value: String?) -> MFMRenderNodeStack {
    let color = value != nil ? Color(hex: value!) : Color.primary
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.foregroundColor(color)
        }
    })
}

/// $[bg.color=ff0000 Red Background]
fileprivate func applyBackgroundColor(_ renderedChildren: MFMRenderResult, value: String?) -> MFMRenderNodeStack {
    let color = value != nil ? Color(hex: value!) : nil
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            if color == nil {
                view
            } else {
                view.background(color!)
            }
        }
    })
}

// MARK: Internal Helpers

/// Internal modifier signature
fileprivate typealias ModifierCallalbleWithValue = (_ renderedChildren: MFMRenderResult, _ value: String?) -> MFMRenderNodeStack

/// Convert the internal modifier callback into a regular MFMRenderModifierCallalble
fileprivate func modifierWrapper(value: String?, inner: @escaping ModifierCallalbleWithValue) -> MFMRenderModifierCallalble {
    return { renderedChildren in
        inner(renderedChildren, value)
    }
}
