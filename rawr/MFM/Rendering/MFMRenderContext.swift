//
//  MFMRenderContext.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation

public class MFMRenderContext {}

public struct TappedHashtag: Codable, Hashable  {
    var hashtag: String
}

public struct TappedMention: Codable, Hashable  {
    var username: String
}
