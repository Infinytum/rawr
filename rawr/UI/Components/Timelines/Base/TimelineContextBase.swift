//
//  TimelineContextBase.swift
//  rawr.
//
//  Created by Nila on 18.08.2023.
//

import Foundation
import MisskeyKit

class TimelineContextBase: ObservableObject {
    /// Set to a string when fetching new items failed
    @Published var fetchError: String? = nil
    
    /// Set to true while the TimelimeContext is fetching new items from the server
    @Published var fetchingItems = false
    
    /// Set to true when data has been loaded for the first time, subsequent initialize calls will not change this value
    @Published var firstLoadCompleted = false
    
    /// A list of all currently available timeline items that have passed pre-rendering
    @Published var items = [TimelineItem]()
    
    /// Returns the amount of available timeline items
    public var count: Int {
        return self.items.count
    }
    
    /// A reference to the backing implementation of the TimelineContextProtocl
    var delegate: TimelineContextProtocol? = nil
    
    /// The identifier of the last item in the list, used to trigger automatic data fetching
    var lastItemId: String? {
        self.items.last?.note.id
    }
    
    /// Resets the TimelineContext and forces a fetch of the most recent items on the timeline
    public func initialize() {
        guard let delegate = self.delegate else {
            print("TimelineContextBase Error: Delegate was not set, missing backing implementation for data fetching")
            return
        }
        
        if self.fetchingItems {
            return
        }
        
        self.items = []
        self.fetchError = nil
        self.fetchingItems = true
        delegate.fetchInitialItems()
    }
    
    /// Check whether the given item warrants fetching of new data. If it does, fetch new data from the server.
    public func fetchItemsIfNeeded(_ item: TimelineItem) {
        guard let delegate = self.delegate else {
            print("TimelineContextBase Error: Delegate was not set, missing backing implementation for data fetching")
            return
        }
        
        if self.fetchingItems {
            return
        }

        if self.lastItemId != nil && item.note.id == self.lastItemId {
            self.fetchingItems = true
            delegate.fetchItems(self.lastItemId!)
        }
    }
    
    /// Handle a bunch of new items to be **appended** to the timeline, including error handling
    internal func handleItems(notes: [NoteModel]?, error: MisskeyKitError?) {
        guard let notes = notes else {
            self.fetchError = "\(error!)"
            self.fetchingItems = false
            print("TimelineContextBase Error: Delegate returned error while fetching items: \(error!)")
            return
        }
        
        Task {
            let newItems = notes.map({ note in
                renderNote(note)
            })

            await MainActor.run {
                items.append(contentsOf: newItems)
                self.firstLoadCompleted = true
                self.fetchError = nil
                self.fetchingItems = false
            }
        }
    }
    
    /// Handle a single item to be **inserted** to the beginning of the timeline
    internal func handleStreamItem(_ response: Any?) {
        guard let note = response as? NoteModel else {
            return
        }
        self.items.insert(renderNote(note), at: 0)
    }
    
    /// Pre-render a note and convert it to a TimelineItem
    private func renderNote(_ note: NoteModel) -> TimelineItem {
        return TimelineItem(note: note, renderedNote: mfmRender(tokenize(note.text ?? note.renote?.text ?? ""), emojis: note.emojis ?? note.renote?.emojis ?? []))
    }
}
