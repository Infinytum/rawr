//
//  NoteEditorView.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NoteEditorView: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var contentWarning: String = ""
    @State var contentWarningShown: Bool = false
    
    @State var noteBody: String = ""
    
    @State var emojiPickerShown: Bool = false
    @State var previewShown: Bool = true
    @State var contentHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack() {
                    VStack(alignment: .leading) {
                        if contentWarningShown {
                            TextField("Content Warning goes here...", text: $contentWarning, axis: .vertical)
                                .font(.body)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .lineLimit(1...)
                            Divider()
                        }
                        TextField("Your note goes here...", text: $noteBody, axis: .vertical)
                            .font(.body)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .lineLimit(10...)
                        if previewShown {
                            Divider()
                            NoteHeader(note: .init(user: self.context.currentUser)).padding(.top, 5)
                            MFMBody(render: mfmRender(tokenize(self.noteBody)))
                                .padding(.top, 5)
                        }
                        Divider()
                        HStack {
                            VStack {
                                Image(systemName: "paperclip")
                                    .fontWeight(.light)
                                    .frame(height: 15)
                                Text("Attach")
                                    .font(.system(size: 12))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .padding(.top, 0.1)
                            }.padding(.all, 5)
                            Spacer()
                            VStack {
                                Image(systemName: "checklist")
                                    .fontWeight(.light)
                                    .frame(height: 15)
                                Text("Poll")
                                    .font(.system(size: 12))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .padding(.top, 0.1)
                            }.padding(.all, 5)
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
                                Image(systemName: "questionmark")
                                    .fontWeight(.light)
                                    .frame(height: 15)
                                Text("Help")
                                    .font(.system(size: 12))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .padding(.top, 0.1)
                            }.padding(.all, 5)
                        }
                    } .padding(.horizontal).padding(.top, 5)
                }
                .padding(.top, 60)
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                    }
                )
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    if let height {
                        self.contentHeight = height
                    }
                }
                .ignoresSafeArea()
            }
            NoteEditorHeader(previewEnabled: $previewShown)
        }.presentationDetents([.height(self.contentHeight)])
    }
}

fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true), content: {
        NoteEditorView()
    })
    .environmentObject(ViewContext())
}
