//
//  MessagesContext.swift
//  rawr.
//
//  Created by Nila on 06.10.2023.
//

import Foundation
import MisskeyKit

class MessagesContext: ObservableObject {
    /// Set to a string when fetching new items failed
    @Published var fetchError: String? = nil
    
    /// Set to true while the MessagesContext is fetching new items from the server
    @Published var fetchingItems = false
    
    /// A list of all currently available message items that have passed pre-rendering
    @Published var items = [MessageHistoryModel]()
    
    /// Returns the amount of available message items
    public var count: Int {
        return self.items.count
    }
    
    /// The identifier of the last item in the list, used to trigger automatic data fetching
    var lastItemId: String? {
        self.items.last?.id
    }
    
    /// Resets the MessagesContext and forces a fetch of the most recent items
    public func initialize() {
        if self.fetchingItems {
            return
        }
        
        self.items = []
        self.fetchError = nil
        self.fetchingItems = true
        // TODO: Firefish API does not support pagination yet, can't load more than 100 entires at all.
        MisskeyKit.shared.messaging.getHistory(limit: 100, result: self.handleItems)
    }
    
    /// Check whether the given item warrants fetching of new data. If it does, fetch new data from the server.
    public func fetchItemsIfNeeded(_ item: TimelineItem) {
        if self.fetchingItems {
            return
        }

        if self.lastItemId != nil && item.note.id == self.lastItemId {
            self.fetchingItems = true
            // TODO: Firefish API does not support pagination yet, can't load more than 100 entires at all.
            self.fetchingItems = false
            //MisskeyKit.shared.notes.getHistory(limit: 5, untilId: self.lastItemId!, completion: self.handleItems)
        }
    }
    
    /// Handle a bunch of new items to be **appended** to the timeline, including error handling
    internal func handleItems(notes: [MessageHistoryModel]?, error: MisskeyKitError?) {
        guard let messages = notes else {
            self.fetchError = "\(error!)"
            print("MessagesContext Error: Delegate returned error while fetching items: \(error!)")
            return
        }
        
        Task {
            await MainActor.run {
                items.append(contentsOf: messages)
                self.fetchError = nil
                self.fetchingItems = false
            }
        }
    }
    
    /// Handle a single item to be **inserted** to the beginning of the timeline
    internal func handleStreamItem(_ response: Any?) {
        guard let message = response as? MessageHistoryModel else {
            return
        }
        self.items.insert(message, at: 0)
    }
}
