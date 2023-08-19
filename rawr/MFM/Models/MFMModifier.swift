//
//  MFMModifier.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation

public enum MFMModifier: String {
    case big = "x2"
    case bigger = "x3"
    case biggest = "x4"
    case fontColour = "fg.color"
    case backgroundColour = "bg.color"
    
    case scaleX = "scale.x"
    case scaleY = "scale.y"
}

// Parse a MFM modifier string (fg.color=000000) into a MFMModifier and optional value
public func parseMFMModifier(_ modifierText: String) ->  (MFMModifier?, String?) {
    let splitModifier = modifierText.split(separator: "=")
    let modifier = splitModifier[0]
    let value = splitModifier.count > 1 ? "\(splitModifier[1])" : nil
    
    guard let parsed = MFMModifier(rawValue: modifier.lowercased()) else {
        return (nil, nil)
    }
    return (parsed, value)
}
