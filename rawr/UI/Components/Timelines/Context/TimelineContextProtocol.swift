//
//  TimelineContextProtocol.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation

protocol TimelineContextProtocol {
    func fetchInitialItems()
    func fetchItems(_ untilId: String)
}
