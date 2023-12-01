//
//  ListModel.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import Foundation
import MisskeyKit

extension ListModel: Identifiable {
    static var preview: ListModel {
        let JSON = """
{
    "id": "9hccz6uflfaowctv",
    "name": "Dragons",
    "createdAt": "2023-07-18T21:16:07.911Z",
    "userIds": []
}
"""
        
        let jsonData = JSON.data(using: .utf8)!
        return try! JSONDecoder().decode(ListModel.self, from: jsonData)
    }
}
