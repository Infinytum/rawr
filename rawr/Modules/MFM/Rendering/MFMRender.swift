//
//  MFMRender.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import MisskeyKit
import SwiftUI
import WrappingHStack

public struct MFMRender {
    let context: MFMRenderContext
    let renderedNote: MFMRenderViewStack
}

func mfmRender(_ rootNode: MFMNodeProtocol, emojis: [EmojiModel] = [], plaintextWordlets: Int = 15) -> MFMRender {
    /// Create Render Context and render all children of the root view
    let renderContext: MFMRenderContext = MFMRenderContext()
    let renderNodeStack: MFMRenderNodeStack = mfmMergeRenderResult(
        rootNode.children.map({ childNode in
            mfmRenderNode(childNode, context: renderContext, emojis: emojis, plaintextWordlets: plaintextWordlets)
        })
    )
    
    /// Render the node stack produced by the children using WrappingHStack elements
    let viewStack = renderNodeStack.map { node in
        return MFMRenderView {
            WrappingHStack(alignment: node.alignment, horizontalSpacing: 0, verticalSpacing: 1) {
                /// Force empty WrappingHStack to take up space since they are supposed to be an empty line
                if node.viewStack.isEmpty {
                    Text("")
                }
                
                ForEach(node.viewStack) { view in
                    view
                }
            }
        }
    }
    
    return MFMRender(
        context: renderContext,
        renderedNote: viewStack
    )
}

fileprivate func mfmRenderNode(_ node: MFMNodeProtocol, context: MFMRenderContext, emojis: [EmojiModel] = [], plaintextWordlets: Int = 15) -> MFMRenderNodeStack {
    /// Pre-render the children of the node (if it has any)
    let renderNodeStack: MFMRenderResult = node.children.map({ childNode in
        mfmRenderNode(childNode, context: context, emojis: emojis, plaintextWordlets: plaintextWordlets)
        })
    
    switch node.type {
    /// The root node does not require node-specific processing. It is merely a container without any modifiers.
    case .root:
        return mfmMergeRenderResult(renderNodeStack)
    /// Plaintext rendering is rather difficult due to line breaks being impossible with one big Text element. Sensible breaking of the plain text into
    /// multiple Text elements is required to make the text flow.
    case .plaintext:
        /// If there is no value, this is not worth rendering.
        guard let plaintext = node.value else {
            return []
        }
        return mfmRenderNodePlaintext(plaintext, plaintextWordlets: plaintextWordlets)
    case .mention:
        /// If there is no value, this is not worth rendering.
        guard let username = node.value else {
            return []
        }
        
        return [
            MFMRenderNode(
                viewStack: [
                    MFMRenderView {
                        NavigationLink(value: TappedMention(username: "@" + username)) {
                            Text("@" + username)
                                .foregroundStyle(.orange)
                        }
                    }
                ],
                newStack: false,
                endStack: false,
                alignment: .leading
            )
        ]
    case .hashtag:
        /// If there is no value, this is not worth rendering.
        guard let hashtag = node.value else {
            return []
        }
        
        return [
            MFMRenderNode(
                viewStack: [
                    MFMRenderView {
                        NavigationLink(value: TappedHashtag(hashtag: hashtag)) {
                            Text("#" + hashtag)
                                .foregroundStyle(.blue)
                        }
                    }
                ],
                newStack: false,
                endStack: false,
                alignment: .leading
            )
        ]
    case .emoji:
        /// If there is no value, this is not worth rendering.
        guard let emojiName = node.value else {
            return []
        }

        return [
            MFMRenderNode(
                viewStack: [
                    MFMRenderView {
                        Emoji(name: emojiName, emojis: emojis)
                    }
                ],
                newStack: false,
                endStack: false,
                alignment: .leading
            )
        ]
    case .bold:
        return mfmMergeRenderResult(renderNodeStack, viewSideEffect:  { view in
            MFMRenderView {
                view
                    .fontWeight(.bold)
            }
        })
    case .center:
        var newStack = true
        return mfmMergeRenderResult(renderNodeStack) { node, isLastNode in
            let newNode = MFMRenderNode(
                viewStack: node.viewStack,
                newStack: newStack || node.newStack,
                endStack: isLastNode || node.endStack,
                alignment: .center
            )
            newStack = false
            return newNode
        }
    case .italic:
        return mfmMergeRenderResult(renderNodeStack, viewSideEffect:  { view in
            MFMRenderView {
                view
                    .italic()
            }
        })
    case .modifier:
        /// If there is no value, return children as is
        guard let modifierName = node.value else {
            return mfmMergeRenderResult(renderNodeStack)
        }
        
        let (modifier, value) = parseMFMModifier(modifierName)
        return mfmRenderModifier(modifier, value: value)(renderNodeStack)
    case .small:
        return mfmMergeRenderResult(renderNodeStack, viewSideEffect:  { view in
            MFMRenderView {
                view
                    .font(.system(size: 14))
            }
        })
    case .url:
        /// If there is no value, return display text as is
        guard let url = node.value else {
            return mfmMergeRenderResult(renderNodeStack)
        }
        
        return mfmMergeRenderResult(renderNodeStack, viewSideEffect:  { view in
            MFMRenderView {
                view
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                    }
            }
        })
    }
}

fileprivate func mfmRenderNodePlaintext(_ plaintext: String, plaintextWordlets: Int = 15) -> MFMRenderNodeStack {
    /// Prepare rendering arrays
    var nodeStack: MFMRenderNodeStack = []
    var viewStack: MFMRenderViewStack = []
    
    /// Prepare helper variables
    let lines = plaintext.components(separatedBy: .newlines)
    let beginsWithBreak = plaintext.first?.isNewline ?? false
    
    for (lineIdx, line) in lines.enumerated() {
        viewStack = []
        
        /// Break line into words to allow for wrapping text
        let words = line.components(separatedBy: .whitespaces)
        for (wordIdx, word) in words.enumerated() {
            
            /// Break up words longer than 15 characters to ensure long words can be rendered correctly with wrapping
            for wordlet in word.split(every: plaintextWordlets) {
                viewStack.append(MFMRenderView {
                    Text(wordlet)
                })
            }
            
            /// Re-apply spaces by rendering individual space text bits.
            /// TODO: Improve this by merging them with the last wordlet
            if wordIdx < words.count - 1 || (word == "" && words.count == 1 && line.count > 0) {
                viewStack.append(MFMRenderView {
                    Text(" ")
                })
            }
        }
        
        /// Line rendering completed, commit viewStack into a rendered
        nodeStack.append(MFMRenderNode(viewStack: viewStack, newStack: lineIdx == lines.startIndex && beginsWithBreak, endStack: lines.count > 1 && lineIdx < lines.count - 1, alignment: .leading))
    }
    
    return nodeStack
}

// Hello @user and @user@instance.local!\nThis is a <center>centered $[tada $[x2 $[sparkle gay]]]</center> #test_2023. Visit:asd :drgn:\n https://www.example.com
// Hello @user how are you doing this is a very long text I hope it will wrap.\nYay it did. Great so far! Nice walk-in rack :drgn: <center> This text should be centered</center> And this shouldn't
fileprivate let testNote = """
**Welcome to rawr.**
This is a test post for <i>rawr.</i>, an iOS-native app for Firefish!


<center>This is the first iOS app made specifically for Firefish
<small>Misskey and Mastodon apps do not count :)</small>
</center>

**Why did we do this?** :drgn_up:
Firefish is seeing more and more adoption, but the lack of proper mobile apps is hurting the process as people are disappointed with the lack of functionality in Misskey apps and the lack of stability and completeness in Mastodon apps.

$[blur And because it was fun]
$[x2 Big :drgn: asd]
$[x2 :drgn_confused:]
$[x3 Bigger :drgn: ad]
$[x4 Biggest :drgn: asd]
Primarily developed by @nila@derg.social and @drafolin@derg.social to improve the user experience of derg.social, we are happy to announce that this app works with any Firefish instance!

#firefish #app #development #developer #announcement #fediverse
"""

fileprivate let testNoteOld = "Hello @user and @user@instance.local!\nThis is a <center>centered **test** $[tada $[x2 $[sparkle gay]]]</center>**test** #test_2023. Visit:asd :drgn:\nhttps://www.example.com\n$[x4 $[bg.color=000000 $[fg.color=00ff00 ***hacker voice* **<i>I'm in</i>]]]\n$[scale.y=2 🍮]\n$[blur This is a spoiler]"

#Preview {
    VStack {
        Spacer()
        ForEach(mfmRender(Tokenizer.note.tokenize(testNote)).renderedNote) { view in
            AnyView(view.view)
        }
        Spacer()
    }.border(.brown).environmentObject(ViewContext())
}
