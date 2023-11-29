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
    case blur = "blur"
    case fontColour = "fg"
    case backgroundColour = "bg"
    
    case scale = "scale"
    
    case rotate = "rotate"
    
    case position = "position"
    
    case flip = "flip"
    
    case spin = "spin"
    case jump = "jump"
    case shake = "shake"
}

public typealias MFMValues = Dictionary<String, String?>

public extension MFMValues {
    
    func get(_ key: String) -> String? {
        guard let val = self[key] else {
            return nil
        }
        return val
    }
    
    func isSet(_ key: String) -> Bool {
        guard let val = self[key] else {
            return false
        }
        return true
    }
    
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

private let mfmRegex = /(\w+)([\.]{1}(.*)){0,1}/

public func parseMFMModifier2(_ modifierText: String) -> (MFMModifier?, MFMValues) {
    var values = MFMValues()
    
    guard let match = modifierText.firstMatch(of: mfmRegex) else {
        return (nil, values)
    }
    
    guard let modifier = MFMModifier(rawValue: match.output.1.lowercased()) else {
        return (nil, values)
    }

    guard let valueString = match.output.3 else {
        return (modifier, values)
    }
    
    for valuePair in valueString.split(separator: ",") {
        let split = valuePair.split(separator: "=", maxSplits: 1)
        let key = split[0]
        values[String(key)] = split.count == 2 ? String(split[1]) : nil
    }
    return (modifier, values)
}
