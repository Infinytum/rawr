//
//  NotificationContext.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import Foundation
import MisskeyKit

class NotificationContext: ObservableObject {
    /// Set to a string when fetching new items failed
    @Published var fetchError: String? = nil
    
    /// Set to true while the NotificationContext is fetching new items from the server
    @Published var fetchingItems = false
    
    /// A list of all currently available timeline items that have passed pre-rendering
    @Published var items = [NotificationModel]()
    
    /// Returns the amount of available timeline items
    public var count: Int {
        return self.items.count
    }
    
    /// The identifier of the last item in the list, used to trigger automatic data fetching
    var lastItemId: String? {
        self.items.last?.id
    }
    
    /// Resets the NotificationContext and forces a fetch of the most recent items on the timeline
    public func initialize() {
        if self.fetchingItems {
            return
        }
        
        self.items = []
        self.fetchError = nil
        self.fetchingItems = true
        
        MisskeyKit.shared.notifications.get(following: false, result: self.handleItems)
    }
    
    /// Check whether the given item warrants fetching of new data. If it does, fetch new data from the server.
    public func fetchItemsIfNeeded(_ item: NotificationModel) {
        if self.fetchingItems {
            return
        }

        if self.lastItemId != nil && item.id == self.lastItemId {
            self.fetchingItems = true
            MisskeyKit.shared.notifications.get(untilId: self.lastItemId!, following: false, result: self.handleItems)
        }
    }
    
    /// Handle a bunch of new items to be **appended** to the timeline, including error handling
    internal func handleItems(notifications: [NotificationModel]?, error: MisskeyKitError?) {
        guard let notifications = notifications else {
            self.fetchError = "\(error!)"
            print("NotificationContext Error: Got returned error while fetching items: \(error!)")
            return
        }
        
        Task {
            await MainActor.run {
                items.append(contentsOf: notifications)
                self.fetchError = nil
                self.fetchingItems = false
            }
        }
    }
    
    /// Handle a single item to be **inserted** to the beginning of the timeline
    internal func handleStreamItem(_ response: Any?) {
        guard let notifications = response as? NotificationModel else {
            return
        }
        self.items.insert(notifications, at: 0)
    }
}
