//
//  HomeTimelineContext.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

class HomeTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.notes.getTimeline(completion: self.handleItems)
        _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.homeTimeline]) { response, _, _, _ in
            self.handleStreamItem(response)
        }
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getTimeline(limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
