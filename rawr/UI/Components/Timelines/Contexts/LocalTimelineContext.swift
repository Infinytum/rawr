//
//  LocalTimelineContext.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

class LocalTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.notes.getLocalTimeline(completion: self.handleItems)
        MisskeyKit.shared.streaming.disconnect()
        _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.localTimeline]) { response, _, _, _ in
            self.handleStreamItem(response)
        }
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getLocalTimeline(limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
