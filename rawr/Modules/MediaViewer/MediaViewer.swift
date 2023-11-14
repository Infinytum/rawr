//
//  MediaViewer.swift
//  rawr.
//
//  Created by Nila on 11.11.2023.
//

import AVKit
import MisskeyKit
import SwiftKit
import SwiftUI

struct MediaViewer: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var files: [File?]
    
    @State var index = 0
    @State private var offset: CGSize = .zero
    @State var showOverlays: Bool = true
    
    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(self.fileList().enumerated()), id: \.1.id) { (index, file) in
                chooseRenderer(file: file)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .offset(y: offset.height)
        .animation(.interactiveSpring(), value: offset)
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { gesture in
                    if gesture.translation.width < 50 {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(offset.height) > 100 {
                        self.dismiss()
                    }
                    offset = .zero
                }
        )
        .safeAreaInset(edge: .top, spacing: 0) {
            if self.showOverlays {
                MediaViewerHeaderOverlay(count: self.fileList().count, file: self.fileList()[self.index], index: self.$index)
                    .transition(.opacity)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if self.showOverlays {
                MediaViewerFooterOverlay(comment: self.fileList()[self.index].comment ?? "No Alt-Text available.")
                    .transition(.opacity)
            }
        }
    }
    
    func fileList() -> [File] {
        self.files.filter { file in
            return file != nil
        }.map { file in
            return file!
        }
    }
    
    func chooseRenderer(file: File) -> AnyView {
        if file.type!.starts(with: "image/gif") {
            return AnyView(MediaViewGifRenderer(url: file.url!).onTapGesture {
                withAnimation {
                    self.showOverlays.toggle()
                }
            })
        }
        if file.type!.starts(with: "image/") {
            return AnyView(MediaViewImageRenderer(url: file.url!).onTapGesture {
                withAnimation {
                    self.showOverlays.toggle()
                }
            })
        }
        if file.type!.starts(with: "video/") {
            return AnyView(MediaViewVideoRenderer(player: AVPlayer(url: URL(string: file.url!)!)))
        }
        return AnyView(Text("Unsupported"))
    }
}

#Preview {
    VStack {
        Text("hi")
        Spacer()
        HStack {
            Spacer()
        }
    }
    .background(.black)
    .fullScreenCover(isPresented: .constant(true), content: {
        MediaViewer(files: NoteModel.preview.renote!.files!)
    }).transaction({ transaction in
        // disable the default FullScreenCover animation
        transaction.disablesAnimations = true

        // add custom animation for presenting and dismissing the FullScreenCover
        transaction.animation = .linear(duration: 1)
      })
    .environmentObject(ViewContext())
}
