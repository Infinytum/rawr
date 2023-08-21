//
//  UserTimelineContext.swift
//  rawr.
//
//  Created by Dråfølin on 8/20/23.
//

import Foundation
import MisskeyKit

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

class UserTimelineContext: TimelineContextBase, TimelineContextProtocol {
    public enum timelineScope: String, CaseIterable, Identifiable {
        case notes = "Notes", withReplies = "Include replies", onlyFiles = "Only files"
        var id: Self { self }
    }
    
    var userID: String
    var scope: timelineScope
    
    init(_ userID: String, _ scope: timelineScope = .notes) {
        self.scope = scope
        self.userID = userID
        super.init()
        self.delegate = self
    }
    
    func fetchInitialItems() {
        print(scope)
        MisskeyKit.shared.notes.getUserNotes(includeReplies: scope == .withReplies, userId: userID, withFiles: scope == .onlyFiles, completion: self.handleItems)
        _ = MisskeyKit.shared.streaming.connect(apiKey: RawrKeychain().apiKey ?? "", channels: [.globalTimeline]) { response, _, _, _ in
            guard let note = response as? NoteModel else {
                return
            }
            guard note.userId == self.userID &&
            (!note.hasFiles()^(self.scope == .onlyFiles)) &&
            ((note.replyId == nil)^(self.scope == .withReplies)) else {
                return
            }
            
            self.handleStreamItem(response)
        }
    }
    
    func fetchItems(_ untilId: String) {
        MisskeyKit.shared.notes.getUserNotes(includeReplies: scope == .withReplies, userId: userID, withFiles: scope == .onlyFiles, limit: 5, untilId: untilId, completion: self.handleItems)
    }
    

}
