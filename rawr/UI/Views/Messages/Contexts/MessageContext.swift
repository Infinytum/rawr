//
//  MessageContext.swift
//  rawr.
//
//  Created by Nila on 06.10.2023.
//

import Foundation
import MisskeyKit

class MessageContext: ObservableObject {
    private var itemsLoadedCount = 0
    private var oldestMessageId: String?
    public var remoteUserId: String = ""
    private var endReached: Bool = false
    
    @Published var errorReason: String? = nil
    @Published var items = [MessageModel]()
    @Published var dataIsLoading = false
    
    /// Used for infinite scrolling. Only requests more items if pagination criteria is met.
    func requestMoreItemsIfNeeded(message: MessageModel) {
        if self.dataIsLoading || self.endReached == true {
            return
        }
        
        if self.oldestMessageId != nil && message.id == self.oldestMessageId {
            requestItems(untilMessageId: self.oldestMessageId!)
        }
    }
    
    func requestInitialSetOfItems(remoteUserId: String) {
        self.remoteUserId = remoteUserId
        oldestMessageId = nil
        items = []
        itemsLoadedCount = 0
        
        MisskeyKit.shared.messaging.getMessageWithUser(userId: self.remoteUserId, limit: 25, markAsRead: true, result: self.handleChatUpdate)
        _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.main]) { response, _, _, _ in
            self.handleStreamMessage(response)
        }
        do {
            try MisskeyKit.shared.streaming.captureChat(self.remoteUserId)
        } catch {
            print("Registering for chat stream failed \(error)")
            MisskeyKit.shared.streaming.disconnect()
        }
    }
    
    private func handleStreamMessage(_ response: Any?) {
        guard let response = response, let message = response as? MessageModel else {
            return
        }
        self.items.insert(message, at: 0)
    }
    
    private func requestItems(untilMessageId: String) {
        dataIsLoading = true
        MisskeyKit.shared.messaging.getMessageWithUser(userId: self.remoteUserId, limit: 25, untilId: untilMessageId, markAsRead: true, result: self.handleChatUpdate)
    }
    
    private func handleChatUpdate(messages: [MessageModel]?, error: MisskeyKitError?) {
        guard let messages = messages else {
            self.errorReason = error?.localizedDescription ?? "Unknown Error"
            print("Error handling chat update")
            print(error.debugDescription)
            return
        }
        if messages.count == 0 {
            self.endReached = true
        }
        Task {
            await MainActor.run {
                self.items.append(contentsOf: messages)
                self.itemsLoadedCount = self.items.count
                self.oldestMessageId = self.items.last?.id
                self.errorReason = nil
                self.dataIsLoading = false
            }
        }
    }
}
