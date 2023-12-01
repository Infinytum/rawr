//
//  ListTimelineContext.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import Foundation
import MisskeyKit

class ListTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    let listId: String
    
    init(_ listId: String) {
        self.listId = listId
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.notes.getUserListTimeline(listId: self.listId, completion: self.handleItems)
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getUserListTimeline(listId: self.listId, limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
