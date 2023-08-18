//
//  Scanner.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation

public extension Scanner {
    func probe(_ searchString: String) -> String? {
        let startLocation = self.currentIndex
        guard let token = self.scanString(searchString) else {
            self.currentIndex = startLocation
            return nil
        }
        return token
    }
}
