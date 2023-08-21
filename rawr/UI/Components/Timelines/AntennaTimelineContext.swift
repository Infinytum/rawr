//
//  AntennaTimelineContext.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import Foundation
import MisskeyKit

class AntennaTimelineContext: TimelineContextBase, TimelineContextProtocol {
    
    let antennaId: String
    
    init(_ antennaId: String) {
        self.antennaId = antennaId
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        MisskeyKit.shared.notes.getAntennaTimeline(antennaId: self.antennaId, completion: self.handleItems)
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getAntennaTimeline(antennaId: self.antennaId, limit: 5, untilId: untilId, completion: self.handleItems)
    }
    
}
