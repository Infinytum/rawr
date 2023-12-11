//
//  NoteModel.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import Foundation
import MisskeyKit

extension NoteModel: ObservableObject {
 
    typealias NoteVisibility = Visibility
    
    // MARK: Commands
    
    // MARK: Reactions
    
    /// Get the URL for any reaction that is present on this note
    func emojiUrlForReaction(name: String) -> String? {
        guard let emojis = self.emojis else {
            return nil
        }
        
        guard let foundEmoji = emojis.filter({ emoji in
            ":" + (emoji.name ?? "") + ":" == name
        }).first else {
            return nil
        }
        
        return foundEmoji.url
    }
    
    /// Check whether the given reaction is already the users reaction for this note
    func isMyReaction(_ reaction: String) -> Bool {
        return (self.myReaction ?? "") == reaction
    }
    
    /// Add a reactions to the note, replacing any existing reaction
    func react(_ reaction: String) async throws {
        if (self.myReaction ?? "") == reaction { return; }
        
        // Handle existing reaction and remove it if necessary
        try await self.unreact()
        
        return try await withCheckedThrowingContinuation { continuation in
            MisskeyKit.shared.notes.createReaction(noteId: self.id!, reaction: reaction) { _, error in
                guard let error = error else {
                    self.myReaction = reaction
                    self.reactions = (self.reactions ?? [:])
                    self.reactions![self.myReaction!] = (self.reactions![self.myReaction!] ?? 0) + 1
                    self.objectWillChange.send()
                    continuation.resume()
                    return
                }
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Remove any existing reaction from the note
    func unreact() async throws {
        guard let _ = self.myReaction else { return }
        return try await withCheckedThrowingContinuation { continuation in
            MisskeyKit.shared.notes.deleteReaction(noteId: self.id!) { _, error in
                guard let error = error else {
                    self.reactions![self.myReaction!]! -= 1
                    if self.reactions![self.myReaction!]! == 0 {
                        self.reactions!.removeValue(forKey: self.myReaction!)
                    }
                    self.myReaction = nil
                    self.objectWillChange.send()
                    continuation.resume()
                    return
                }
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Vote for a choice in a single-choice poll
    func vote(_ index: Int) async throws {
        guard let _ = self.poll?.votedForChoices else {
            return try await withCheckedThrowingContinuation { continuation in
                MisskeyKit.shared.notes.vote(noteId: self.id!, choice: index) { _, error in
                    guard let error = error else {
                        self.poll!.choices![index]?.isVoted = true
                        self.objectWillChange.send()
                        continuation.resume()
                        return
                    }
                    continuation.resume(throwing: error)
                }
            }
        }
        return
    }
    
    func reactionsCount() -> Int {
        guard let reactions = self.reactions else {
            return 0
        }
        
        var total = 0
        for pair in reactions {
            total += pair.value
        }
        return total
    }
    
    // MARK: Random Helper Functions
    
    func hasCW() -> Bool {
        return self.cw != nil
    }
    
    func hasFiles() -> Bool {
        return self.files != nil
    }
    
    func isRenote() -> Bool {
        return self.renote != nil
    }
    
    func isQuoteRenote() -> Bool {
        return self.isRenote() && self.text != nil
    }
    
    func absoluteUrl() -> URL {
        if self.url != nil {
            return URL(string: self.url!)!
        } else {
            // Notes from the local instance do not contain their URL.
            return URL(string: "https://\(RawrKeychain().instanceHostname)/notes/\(self.id!)")!
        }
    }
    
    func absoluteLocalUrl() -> URL {
        return URL(string: "https://\(RawrKeychain().instanceHostname)/notes/\(self.id!)")!
    }
}
// MARK: - Poll
extension Poll {
    static var preview: Poll {
        var poll: Poll = .init()
        let choicesJSON = """
[
    {
        "text": "Dergs are cute.",
        "votes": 100,
        "isVoted": false
    },
    {
        "text": "Dergs aren't cute.",
        "votes": 0,
        "isVoted": false
    },
    {
        "text": "Dergs are the cutest things ever and i wanna cuddle with them.",
        "votes": 1234123,
        "isVoted": false
    }
]
"""
        let choicesData = choicesJSON.data(using: .utf8)
        let choices: [Choice?] = try! JSONDecoder().decode(Array<Choice>.self, from: choicesData!)
        poll.choices = choices
        poll.multiple = false
        
        return poll
    }
    
    var votedForChoices: [Int]? {
        let votedChoices = Array(self.choices!.enumerated())
            .filter({$0.1?.isVoted ?? false})
        
        guard votedChoices.count >= 1 else {
            return nil
        }
        
        return votedChoices.map({$0.offset})
    }
    
    var totalVotes: Int {
        self.choices!.map({$0?.votes}).reduce(0) {total, value in
            total + (value ?? 0)
        }
    }
}
