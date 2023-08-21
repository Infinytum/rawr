//
//  MFMRenderContext.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation

public class MFMRenderContext {
    var hashtagHandler: ((_ hashtag: String) -> Void)?
    var mentionHandler: ((_ username: String) -> Void)?
    
    /// Fire an event when a hashtag has been tapped by the user
    func tapHashtag(_ hashtag: String) {
        guard let hashtagHandler = hashtagHandler else {
            return
        }
        hashtagHandler(hashtag)
    }
    
    /// Register a tap handler for hashtags inside a pre-rendered note
    func onHashtagTap(result callback: @escaping (_ hashtag: String) -> Void) {
        self.hashtagHandler = callback
    }
    
    /// Fire an event when a hashtag has been tapped by the user
    func tapMention(_ username: String) {
        guard let mentionHandler = mentionHandler else {
            return
        }
        mentionHandler(username)
    }
    
    /// Register a tap handler for mentions inside a pre-rendered note
    func onMentionTap(result callback: @escaping (_ username: String) -> Void) {
        self.mentionHandler = callback
    }
}
