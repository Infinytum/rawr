//
//  TimelineItem.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

// TimelineItem contains a note alongside its rendered counterpart. This allows for pre-rendering!
struct TimelineItem {
    let note: NoteModel
    let renderedNote: [IdentifiableView]
}
