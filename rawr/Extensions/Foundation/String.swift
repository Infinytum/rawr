//
//  String.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation
import CryptoKit

public extension String {
    func sha256() -> String {
        return SHA256.hash(data: Data(self.utf8)).description
    }
    /// Splits a string into groups of `every` n characters, grouping from left-to-right by default. If `backwards` is true, right-to-left.
    func split(every: Int, backwards: Bool = false) -> [String] {
        var result = [String]()

        for i in stride(from: 0, to: self.count, by: every) {
            switch backwards {
            case true:
                let endIndex = self.index(self.endIndex, offsetBy: -i)
                let startIndex = self.index(endIndex, offsetBy: -every, limitedBy: self.startIndex) ?? self.startIndex
                result.insert(String(self[startIndex..<endIndex]), at: 0)
            case false:
                let startIndex = self.index(self.startIndex, offsetBy: i)
                let endIndex = self.index(startIndex, offsetBy: every, limitedBy: self.endIndex) ?? self.endIndex
                result.append(String(self[startIndex..<endIndex]))
            }
        }

        return result
    }
}

public extension String? {
    /// Append a possibly nil string to the current possibly nil string, returning either nil or the resulting string.
    func append(maybeString: String?) -> String? {
        if self == nil && maybeString == nil {
            return nil
        }
        
        return (self ?? "") + (maybeString ?? "")
    }
}
