//
//  HashtagTimeline.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

class HashtagTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    let hashtag: String
    
    init(_ tag: String) {
        self.hashtag = tag
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.search.notesByTag(tag: self.hashtag, completion: self.handleItems)
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.search.notesByTag(tag: self.hashtag, limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
