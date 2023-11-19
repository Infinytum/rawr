//
//  NoteTokenizer.swift
//  rawr.
//
//  Created by Nila on 15.11.2023.
//

import Foundation
import MisskeyKit
import SwiftUI

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Visualizer(rootNode: Tokenizer.note.tokenize(
"""
Hello World

This is a test note to test tokenizing capabilities of rawr.

As you can see we need to test every possible module :star:

<small>Well you are about to see at least</small>

This test note was written by @nila also known as @nila@derg.social
- Pretty cool right?

<center>So why did I write my name twice?
So I could check for username only and full mentions!</center>

**Not because I like to see my name**

<small><i>Getting awkward...</i></small>

$[x2 All in the name of a complete test post!]

Check out my website https://bad-dragon.ch

Or my [GitHub](https://github.com/nilathedragon)

#dragon #rawr #app
"""
        )).scaleEffect(0.5)
    }
    .defaultScrollAnchor(.center)
    .previewDisplayName("Test Note 1")
}

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Visualizer(rootNode: Tokenizer.username.tokenize(
"""
NilaTheDragon@derg.social:~:therian: :idle:
"""
        )).scaleEffect(0.5)
    }
    .defaultScrollAnchor(.center)
    .previewDisplayName("Username Test")
}
