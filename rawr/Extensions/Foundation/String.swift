//
//  String.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import Foundation

public extension String? {
    
    func append(maybeString: String?) -> String? {
        if self == nil && maybeString == nil {
            return nil
        }
        
        return (self ?? "") + (maybeString ?? "")
    }
    
}
