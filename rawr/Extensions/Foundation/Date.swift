//
//  Date.swift
//  rawr.
//
//  Created by Nila on 11.12.2023.
//

import Foundation

struct CustomRelativeDate: FormatStyle, Decodable, Encodable {
    typealias FormatInput = Date
    typealias FormatOutput = String
    
    let to: Date
    let later: Bool

    func format(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        var str = formatter.localizedString(for: date, relativeTo: to)
        if self.later {
            str = str.replacing("ago", with: "later")
        }
        return str
    }
}

extension FormatStyle where Self == CustomRelativeDate {
    static func customRelative(to: Date = Date()) -> Self {
        return CustomRelativeDate(to: to, later: false)
    }
    static func customRelativeLater(to: Date = Date()) -> Self {
        return CustomRelativeDate(to: to, later: true)
    }
}
