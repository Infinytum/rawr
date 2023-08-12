//
//  TimelineContext.swift
//  Derg Social
//
//  Created by Nila on 12.08.2023.
//

import Foundation
import MisskeyKit

enum TimelineContextTimeline: String {
    case HOME = "home"
    case LOCAL = "local"
    case GLOBAL = "global"
}

class TimelineContext: ObservableObject {
    private var itemsLoadedCount = 0
    private var lastNoteId: String?
    private var timeline: TimelineContextTimeline = TimelineContextTimeline.HOME
    
    @Published var errorReason: String? = nil
    @Published var items = [NoteModel]()
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
            break;
        case .LOCAL:
            MisskeyKit.shared.notes.getLocalTimeline(completion: self.handleTimelineUpdate)
            break;
        case .GLOBAL:
            MisskeyKit.shared.notes.getGlobalTimeline(completion: self.handleTimelineUpdate)
            break;
        }
    }
    
    private func requestItems(untilNoteId: String) {
        dataIsLoading = true
        switch (self.timeline) {
        case .HOME:
            MisskeyKit.shared.notes.getTimeline(untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        case .LOCAL:
            MisskeyKit.shared.notes.getLocalTimeline(untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        case .GLOBAL:
            MisskeyKit.shared.notes.getGlobalTimeline(untilId: untilNoteId, completion: self.handleTimelineUpdate)
            break;
        }
    }
    
    private func handleTimelineUpdate(notes: [NoteModel]?, error: MisskeyKitError?) {
        guard let notes = notes else {
            self.errorReason = error?.localizedDescription ?? "Unknown Error"
            print(error.debugDescription)
            return
        }
        Task {
            await MainActor.run {
                items.append(contentsOf: notes)
                itemsLoadedCount = items.count
                self.lastNoteId = items.last?.id
                self.errorReason = nil
                dataIsLoading = false
            }
        }
    }
}
