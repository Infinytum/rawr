//
//  MFMBody.swift
//  rawr.
//
//  Created by Nila on 22.08.2023.
//

import SwiftUI

struct MFMBody: View {
    
    let render: MFMRender
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewRefresher = ViewReloader()
    
    var body: some View {
        VStack {
            ForEach(self.render.renderedNote) { view in
                AnyView(view.view)
            }
        }
    }
}

#Preview {
    MFMBody(render: mfmRender(Tokenizer.note.tokenize("Hello @user and @user@instance.local!\nThis is a <center>centered **test** $[tada $[x2 $[sparkle gay]]]</center>**test** #test_2023. Visit:asd :drgn:\nhttps://www.example.com\n$[x4 $[bg.color=000000 $[fg.color=00ff00 ***hacker voice* **<i>I'm in</i>]]]\n$[scale.y=2 🍮]\n$[blur This is a spoiler]")))
        .environmentObject(ViewContext())
}

