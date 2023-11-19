//
//  NoteEditorView.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import MisskeyKit
import SwiftUI

struct NoteEditorView: View {
    
    @EnvironmentObject var context: ViewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var contentWarning: String = ""
    @State var contentWarningShown: Bool = false
    
    @State var noteBody: String = ""
    @State var visibility: NoteModel.NoteVisibility = .public
    
    @State var sending: Bool = false
    @State var previewShown: Bool = true
    @State var localOnly: Bool = false
    @State var contentHeight: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
                if self.sending {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack() {
                            VStack(alignment: .leading) {
                                if previewShown {
                                    NoteHeader(note: .init(user: self.context.currentUser)).padding(.top, 5)
                                    MFMBody(render: mfmRender(Tokenizer.note.tokenize(self.noteBody)))
                                        .padding(.top, 5)
                                    Divider()
                                }
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
                                    .id(1)
                                
                            } .padding(.horizontal).padding(.top, 5)
                        }
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
                    .safeAreaInset(edge: .top, content: {
                        NoteEditorHeader(previewEnabled: $previewShown, localOnly: $localOnly) {
                            self.sending = true
                            MisskeyKit.shared.notes.createNote(visibility: self.visibility, text: self.noteBody, cw: self.getContentWarning(), localOnly: self.localOnly) { _, error in
                                if error == nil {
                                    self.dismiss()
                                    return
                                }
                                sending = false
                                context.applicationError = ApplicationError(title: "Post failed", message: error.explain())
                            }
                        }
                    })
                    .safeAreaInset(edge: .bottom, content: {
                        NoteEditorFooter(contentWarningShown: self.$contentWarningShown, noteBody: self.$noteBody, visibility: self.$visibility)
                    })
                    .onChange(of: self.noteBody) { _ in
                        proxy.scrollTo(1, anchor: .bottom)
                    }
            }
        }
        .presentationDetents([.fraction(self.sending ? 0.3 : 1)])
    }
    
    private func getContentWarning() -> String {
        if !self.contentWarningShown {
            return ""
        }
        return self.contentWarning
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
