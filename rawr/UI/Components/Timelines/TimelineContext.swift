//
//  TimelineContext.swift
//  Derg Social
//
//  Created by Nila on 12.08.2023.
//

import Foundation
import MisskeyKit
import SwiftUI

enum TimelineContextTimeline: String {
    case HOME = "home"
    case LOCAL = "local"
    case GLOBAL = "global"
}

struct TimelineItem {
    let note: NoteModel
    let renderedNote: [any View]
}

class TimelineContext: ObservableObject {
    private var itemsLoadedCount = 0
    private var lastNoteId: String?
    private var timeline: TimelineContextTimeline = TimelineContextTimeline.HOME
    
    @Published var errorReason: String? = nil
    @Published var items = [TimelineItem]()
    @Published var dataIsLoading = false
    
    
    init(timelineType: TimelineContextTimeline) {
        self.timeline = timelineType
    }
    
    /// Used for infinite scrolling. Only requests more items if pagination criteria is met.
    func requestMoreItemsIfNeeded(note: NoteModel) {
        if self.dataIsLoading {
            return
        }
        
        if self.lastNoteId != nil && note.id == self.lastNoteId {
            requestItems(untilNoteId: self.lastNoteId!)
        }
    }
    
    func requestInitialSetOfItems() {
        lastNoteId = nil
        items = []
        itemsLoadedCount = 0
        
        switch (self.timeline) {
        case .HOME:
            MisskeyKit.shared.notes.getTimeline(completion: self.handleTimelineUpdate)
            _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.homeTimeline]) { response, _, _, _ in
                self.handleStreamMessage(response)
            }
            break;
        case .LOCAL:
            MisskeyKit.shared.notes.getLocalTimeline(completion: self.handleTimelineUpdate)
            _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.localTimeline]) { response, _, _, _ in
                self.handleStreamMessage(response)
            }
            break;
        case .GLOBAL:
            MisskeyKit.shared.notes.getGlobalTimeline(completion: self.handleTimelineUpdate)
            _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.globalTimeline]) { response, _, _, _ in
                self.handleStreamMessage(response)
            }
            break;
        }
    }
    
    private func handleStreamMessage(_ response: Any?) {
        guard let response = response, let message = response as? NoteModel else {
            return
        }
        self.items.insert(noteToTimelineItem(note: message), at: 0)
    }
    
    private func requestItems(untilNoteId: String) {
        dataIsLoading = true
        switch (self.timeline) {
        case .HOME:
            MisskeyKit.shared.notes.getTimeline(limit: 5, untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        case .LOCAL:
            MisskeyKit.shared.notes.getLocalTimeline(limit: 5, untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        case .GLOBAL:
            MisskeyKit.shared.notes.getGlobalTimeline(limit: 5, untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        }
    }
    
    private func handleTimelineUpdate(notes: [NoteModel]?, error: MisskeyKitError?) {
        guard let notes = notes else {
            self.errorReason = error?.localizedDescription ?? "Unknown Error"
            print("Error handling timeline update")
            print(error.debugDescription)
            return
        }
        Task {
            await MainActor.run {
                items.append(contentsOf: notes.map({ note in
                    noteToTimelineItem(note: note)
                }))
                itemsLoadedCount = items.count
                self.lastNoteId = items.last?.note.id
                self.errorReason = nil
                dataIsLoading = false
            }
        }
    }
    
    private func noteToTimelineItem(note: NoteModel) -> TimelineItem {
        return TimelineItem(note: note, renderedNote: renderMFM(tokenize(note.text ?? note.renote?.text ?? ""), emojis: note.emojis ?? note.renote?.emojis ?? []))
    }
}
