//
//  NoteEditorView.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NoteEditorView: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var noteBody: String = ""
    @State var previewShown: Bool = false
    @State var contentHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack() {
                    VStack(alignment: .leading) {
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
                            Image(systemName: "tray.and.arrow.up.fill")
                                .padding(.all, 5)
                            Image(systemName: "music.mic")
                                .padding(.all, 5)
                            Image(systemName: "eye.slash")
                                .padding(.all, 5)
                            Image(systemName: "at")
                                .padding(.all, 5)
                            Image(systemName: "number")
                                .padding(.all, 5)
                            Image(systemName: "face.smiling")
                                .padding(.all, 5)
                            Spacer()
                            Image(systemName: "questionmark")
                                .padding(.all, 5)
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
