//
//  MFMRenderModifier.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import SwiftUI

public typealias MFMRenderModifierCallalble = (_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack

public func mfmRenderModifier(_ mfmModifier: MFMModifier?, value: MFMValues) -> MFMRenderModifierCallalble {
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
    case .blur:
        return applyBlur
    case .fontColour:
        return modifierWrapper(value: value, inner: applyFontColour)
    case .backgroundColour:
        return modifierWrapper(value: value, inner: applyBackgroundColor)
    case .scale:
        return modifierWrapper(value: value, inner: applyScale)
    case .rotate:
        return modifierWrapper(value: value, inner: applyRotate)
    case .position:
        return modifierWrapper(value: value, inner: applyPosition)
    case .flip:
        return modifierWrapper(value: value, inner: applyFlip)
    case .spin:
        return modifierWrapper(value: value, inner: applySpin)
    case .jump:
        return modifierWrapper(value: value, inner: applyJump)
    case .shake:
        return modifierWrapper(value: value, inner: applyShake)
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
            view.font(.system(size: 20)).environment(\.emojiRenderSize, CGSize(width: 50, height: 50))
        }
    })
}

/// $[x3 Bigger Text]
fileprivate func applyBiggerModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.font(.system(size: 24)).environment(\.emojiRenderSize, CGSize(width: 60, height: 60))
        }
    })
}

/// $[x4 Biggest Text]
fileprivate func applyBiggestModifier(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.font(.system(size: 28)).environment(\.emojiRenderSize, CGSize(width: 70, height: 70))
        }
    })
}

/// $[blur Blurred Text]
fileprivate func applyBlur(_ renderedChildren: MFMRenderResult) -> MFMRenderNodeStack {
    let blurContext = BlurViewContext()
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            BlurView {
                view
            }.environmentObject(blurContext)
        }
    })
}

/// $[fg.color=ff0000 Red Text]
fileprivate func applyFontColour(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let color = values.isSet("color") ? Color(hex: values.get("color")!) : Color.primary
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.foregroundColor(color)
        }
    })
}

/// $[bg.color=ff0000 Red Background]
fileprivate func applyBackgroundColor(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let color = values.isSet("color") ? Color(hex: values.get("color")!) : nil
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

/// $[scale.x=1.3 Scaled Text], $[scale.y=1.3 Scaled Text]
fileprivate func applyScale(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let x = (try? Float(values.get("x") ?? "", format: .number)) ?? 1.0
    let y = (try? Float(values.get("y") ?? "", format: .number)) ?? 1.0
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view.scaleEffect(x: CGFloat(x), y: CGFloat(y), anchor: .center)
        }
    })
}

/// $[rotate.deg=45 Hello, world!], $[rotate Hello, world!], $[rotate.x,deg=45 Hello, world!], $[rotate.x Hello, world!]
fileprivate func applyRotate(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let isX = values.isSet("x")
    let isY = values.isSet("y")
    let deg = (try? Double(values.get("deg") ?? "90", format: .number)) ?? 90.0
    
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            if isX {
                view.rotation3DEffect(
                    .init(degrees: deg), axis: (x: 1.0, y: .zero, z: .zero)
                )
            } else if isY {
                view.rotation3DEffect(
                    .init(degrees: deg), axis: (x: .zero, y: 1.0, z: .zero)
                )
            } else {
                view.rotationEffect(.degrees(deg), anchor: .center)
            }
        }
    })
}

/// $[position.x Offset Text], $[position.y Offset Text], $[position.y,x Offset Text]
fileprivate func applyPosition(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let x = (try? Float(values.get("x") ?? "", format: .number)) ?? 0.0
    let y = (try? Float(values.get("y") ?? "", format: .number)) ?? 0.0
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view
                .offset(x: CGFloat(x * 18.5), y: CGFloat(y * 18.5))
        }
    })
}


fileprivate func applyFlip(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let isH = values.isSet("h")
    let isV = values.isSet("v")
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            view
                .transformEffect(CGAffineTransform(scaleX: isH ? -1 : 1, y: isV ? -1 : 1))
        }
    })
}

/// $[spin Spin Text]
fileprivate func applySpin(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let alternate = values.isSet("alternate")
    let isX = values.isSet("x")
    let isY = values.isSet("y")
    let reverse = values.isSet("left")
    let loops = (try? Int(values.get("loop") ?? "0", format: .number)) ?? 0
    let delay = (try? Double((values.get("delay") ?? "0s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 0
    
    let speedSeconds = (try? Int((values.get("speed") ?? "2s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 2
    let speed = 1.0 / Double(speedSeconds)
    
    var animation = MFMAnimation.spin
    if isX {
        animation = .spinX
    } else if isY {
        animation = .spinY
    }
    
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            MFMAnimationView(animation: animation, autoreverse: alternate, delay: delay, loop: loops, speed: speed, reverse: reverse) {
                view
            }
        }
    })
}

/// $[jump Jump Text]
fileprivate func applyJump(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let loops = (try? Int(values.get("loop") ?? "0", format: .number)) ?? 0
    let delay = (try? Double((values.get("delay") ?? "0s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 0
    
    let speedSeconds = (try? Int((values.get("speed") ?? "1s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 1
    let speed = 1.0 / Double(speedSeconds) * 4
    
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            MFMAnimationView(animation: .jump, autoreverse: true, delay: delay, loop: loops, speed: speed, reverse: false) {
                view
            }
        }
    })
}

/// $[shake Shake Text]
fileprivate func applyShake(_ renderedChildren: MFMRenderResult, values: MFMValues) -> MFMRenderNodeStack {
    let loops = (try? Int(values.get("loop") ?? "0", format: .number)) ?? 0
    let delay = (try? Double((values.get("delay") ?? "0s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 0
    
    let speedSeconds = (try? Int((values.get("speed") ?? "1s").replacingOccurrences(of: "s", with: ""), format: .number)) ?? 1
    let speed = 1.0 / Double(speedSeconds) * 4
    
    return mfmMergeRenderResult(renderedChildren, viewSideEffect:  { view in
        MFMRenderView {
            MFMAnimationView(animation: .shake, autoreverse: true, delay: delay, loop: loops, speed: speed, reverse: false) {
                view
            }
        }
    })
}

// MARK: Internal Helpers

/// Internal modifier signature
fileprivate typealias ModifierCallalbleWithValue = (_ renderedChildren: MFMRenderResult, _ value: MFMValues) -> MFMRenderNodeStack

/// Convert the internal modifier callback into a regular MFMRenderModifierCallalble
fileprivate func modifierWrapper(value: MFMValues, inner: @escaping ModifierCallalbleWithValue) -> MFMRenderModifierCallalble {
    return { renderedChildren in
        inner(renderedChildren, value)
    }
}
