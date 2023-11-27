//
//  RenderingTests.swift
//  rawr.
//
//  Created by Nila on 26.11.2023.
//

import Foundation
import SwiftUI

#Preview {
    VStack {
        Spacer()
        ForEach(mfmRender(Tokenizer.note.tokenize("""
$[spin 🍮] $[spin.left 🍮] $[spin.alternate 🍮]
$[spin.x 🍮] $[spin.x,left 🍮] $[spin.x,alternate 🍮]
$[spin.y 🍮] $[spin.y,left 🍮] $[spin.y,alternate 🍮]

$[spin.speed=3s 🍮] $[spin.delay=3s 🍮] $[spin.loop=3 🍮]

$[jump 🍮] $[jump.speed=3s 🍮] $[jump.delay=3s 🍮] $[jump.loop=3 🍮]
"""), emojis: [.init(id: "", aliases: nil, name: "dragnowo", url: "https://cdn.derg.social/calckey/e1deb8ae-e099-4853-b9ea-943c6235abe3.png", uri: "", category: "")]).renderedNote) { view in
            AnyView(view.view)
        }
        Spacer()
    }.border(.brown).environmentObject(ViewContext())
}

