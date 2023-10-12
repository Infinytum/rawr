//
//  NoteEditorFooter.swift
//  rawr.
//
//  Created by Nila on 12.10.2023.
//

import MisskeyKit
import SwiftUI

struct NoteEditorFooter: View {
    
    @Binding var contentWarningShown: Bool
    @Binding var noteBody: String
    @Binding var visibility: NoteModel.NoteVisibility
    
    @State private var emojiPickerShown: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "paperclip")
                    .fontWeight(.light)
                    .frame(height: 15)
                Text("Attach")
                    .font(.system(size: 12))
                    .foregroundColor(.primary.opacity(0.8))
                    .padding(.top, 0.1)
            }.padding(.all, 5).opacity(0.5)
            Spacer()
            VStack {
                Image(systemName: "checklist")
                    .fontWeight(.light)
                    .frame(height: 15)
                Text("Poll")
                    .font(.system(size: 12))
                    .foregroundColor(.primary.opacity(0.8))
                    .padding(.top, 0.1)
            }.padding(.all, 5).opacity(0.5)
            Spacer()
            Button {
                contentWarningShown.toggle()
            } label: {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .fontWeight(.light)
                        .frame(height: 15)
                        .foregroundColor(self.contentWarningShown ? .red : .primary)
                    Text("CW")
                        .font(.system(size: 12))
                        .foregroundColor(.primary.opacity(0.8))
                        .padding(.top, 0.1)
                }.transaction { transaction in
                    transaction.animation = nil
                }
            }.padding(.all, 5)
            Spacer()
            Button {
                emojiPickerShown = true
            } label: {
                VStack {
                    Image(systemName: "hands.sparkles")
                        .fontWeight(.light)
                        .frame(height: 15)
                        .foregroundColor(.primary)
                    Text("Emojis")
                        .font(.system(size: 12))
                        .foregroundColor(.primary.opacity(0.8))
                        .padding(.top, 0.1)
                }.transaction { transaction in
                    transaction.animation = nil
                }
            }.padding(.all, 5)
                .popover(isPresented: self.$emojiPickerShown, content: {
                    EmojiPicker { name in
                        self.noteBody += ":\(name): "
                        self.emojiPickerShown = false
                    }.presentationCompactAdaptation(.popover).padding()
                })
            Spacer()
            VStack {
                Menu {
                    Button("Direct Message") {
                        visibility = .specified
                    }
                    Button("Followers") {
                        visibility = .followers
                    }
                    Button("Unlisted") {
                        visibility = .home
                    }
                    Button("Public") {
                        visibility = .public
                    }
                } label: {
                    VStack {
                        Group {
                            if (visibility == .public) {
                                Image(systemName: "globe")
                            }
                            if (visibility == .home) {
                                Image(systemName: "house")
                            }
                            if (visibility == .followers) {
                                Image(systemName: "lock")
                            }
                            if (visibility == .specified) {
                                Image(systemName: "envelope")
                            }
                        }
                        .foregroundColor(.primary)
                        .fontWeight(.light)
                        .frame(height: 15)
                        Group {
                            if (visibility == .public) {
                                Text("Public")
                            }
                            if (visibility == .home) {
                                Text("Unlisted")
                            }
                            if (visibility == .followers) {
                                Text("Followers")
                            }
                            if (visibility == .specified) {
                                Text("DM")
                            }
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.primary.opacity(0.8))
                        .padding(.top, 0.1)
                    }.contentShape(Rectangle())
                }
            }.padding(.all, 5)
        }.padding(.horizontal).padding(.vertical, 10).fluentBackground(.regular, fullscreen: false)
    }
}

#Preview {
    NoteEditorFooter(contentWarningShown: .constant(false), noteBody: .constant(""), visibility: .constant(.home))
        .environmentObject(ViewContext())
}
