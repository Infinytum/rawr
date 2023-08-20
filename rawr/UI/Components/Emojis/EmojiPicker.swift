//
//  EmojiPicker.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import MisskeyKit
import SwiftUI
import WrappingHStack

fileprivate typealias EmojiPickerDictionary<T> = [String:[T]]

fileprivate struct EmojiPickerEntry {
    let name: String
    let imageUrl: String?
    let emojiChar: String?
}

struct EmojiPicker: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State private var customEmojis: [(String, [EmojiModel])]? = nil
    @State private var defaultEmojis: [(String, [DefaultEmojiModel])]? = nil
    
    @State private var emojis2:  [(String, [EmojiPickerEntry])]? = []
    
    @State var callback: (_ name: String) -> Void
    
    var body: some View {
        if self.customEmojis == nil || self.defaultEmojis == nil {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear(perform: self.onAppear)
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    if self.customEmojis != nil && !self.customEmojis!.isEmpty {
                        Text("Instance Emojis")
                            .foregroundColor(.gray)
                        ForEach(self.customEmojis!, id: \.0) { (category, emojis) in
                            DisclosureGroup {
                                WrappingHStack(alignment: .leading) {
                                    ForEach(emojis) { emoji in
                                        RemoteImage(emoji.url)
                                            .frame(width: 35, height: 35)
                                            .clipped()
                                            .onTapGesture {
                                                callback(emoji.name!)
                                            }
                                    }
                                }.padding(.top, 15)
                            } label: {
                                Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                            }
                        }
                        Divider()
                            .padding(.bottom, 5)
                    }
                    Text("Default Emojis")
                        .foregroundColor(.gray)
                    ForEach(self.defaultEmojis!, id: \.0) { (category, emojis) in
                        DisclosureGroup {
                            WrappingHStack(alignment: .leading) {
                                ForEach(emojis) { emoji in
                                    Text(emoji.char!)
                                        .frame(width: 31, height: 31)
                                        .font(.system(size: 31))
                                        .onTapGesture {
                                            callback(emoji.name!)
                                        }
                                }
                            }.padding(.top, 15)
                        } label: {
                            Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                        }
                    }
                }
            }
        }
    }
    
    private func onAppear() {
        MisskeyKit.shared.emojis.getDefault { defaultEmojis in
            var emojiDict = EmojiPickerDictionary<DefaultEmojiModel>()
            for emoji in defaultEmojis ?? [] {
                let category = emoji.category?.rawValue ?? "uncategorized"
                emojiDict[category] = emojiDict[category] ?? []
                emojiDict[category]?.append(emoji)
            }
            self.defaultEmojis = emojiDict.sorted(by: { $0.0.lowercased() < $1.0.lowercased() })
        }
        
        var customEmojiDict = EmojiPickerDictionary<EmojiModel>()
        for emoji in self.context.currentInstance?.emojis ?? [] {
            let category = emoji.category ?? "uncategorized"
            customEmojiDict[category] = customEmojiDict[category] ?? []
            customEmojiDict[category]?.append(emoji)
        }
        self.customEmojis = customEmojiDict.sorted(by: { $0.0.lowercased() < $1.0.lowercased() })
    }
}

#Preview {
    EmojiPicker() { name in
        print(name)
    }
        .environmentObject(ViewContext())
        .padding()
}
