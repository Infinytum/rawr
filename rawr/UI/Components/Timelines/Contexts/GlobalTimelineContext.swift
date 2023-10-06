//
//  GlobalTimelineContext.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

class GlobalTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.notes.getGlobalTimeline(completion: self.handleItems)
        MisskeyKit.shared.streaming.disconnect()
        _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.globalTimeline]) { response, _, _, _ in
            self.handleStreamItem(response)
        }
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getGlobalTimeline(limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
