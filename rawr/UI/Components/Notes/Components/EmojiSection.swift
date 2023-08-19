//
//  SwiftUIView.swift
//  rawr.
//
//  Created by Dråfølin on 8/18/23.
//

import SwiftUI
import WrappingHStack
import MisskeyKit

struct EmojiSection: View {
    @State var emojiContent: [emoji]
    @State var categoryName: String
    @State private var isDeployed = false
    @State var callback: (_ name: String) -> Void
    
    var body: some View {
        Section {
            WrappingHStack {
                ForEach(isDeployed ? emojiContent : Array(emojiContent.prefix(7)), id: \.name) { emoji in
                    if emoji.image != nil {
                        emoji.image!
                            .onTapGesture {
                                callback(emoji.name)
                            }
                            .frame(width: 31, height: 31)
                            .clipped()
                    } else {
                        emoji.emojiChar!
                            .frame(width: 31, height: 31)
                            .font(.system(size: 31))
                            .onTapGesture {
                                callback(emoji.name)
                            }
                    }
                }
            }
        } header: {
            Button {
                withAnimation {
                    isDeployed.toggle()
                }
            } label:{
                HStack {
                    Text(categoryName.capitalized)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(isDeployed ? .init(degrees: 90) : .zero)
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    @State var emojis: [emoji] = []
    @State var presentSheet = false
    MisskeyKit.shared.emojis.getDefault { defaultEmojis in
        defaultEmojis?.filter {emoji in
            emoji.category == .people
        }.forEach {emoji in
            emojis.append(.init(name: "\(emoji.name!)", emojiChar: Text(emoji.char!)))
        }
        presentSheet = true
    }
    
    return VStack{}
        .sheet(isPresented: $presentSheet) {
            List {
                EmojiSection(emojiContent: emojis, categoryName: "people") {_ in
                    
                }
            }
            .foregroundStyle(.primary)
    }
}
