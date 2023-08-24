//
//  AntennaModel.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import Foundation
import MisskeyKit

extension AntennaModel: Identifiable {
    static var preview: AntennaModel {
        let JSON = """
{
    "id": "9h7k6mbkq9",
    "name": "Dragons"
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(AntennaModel.self, from: jsonData)
    }
}
