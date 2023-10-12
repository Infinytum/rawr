//
//  BetterNoteBodyGallery.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import Agrume
import NetworkImage
import MisskeyKit
import SwiftUI

struct BetterNoteBodyGallery: View {
    
    @ObservedObject var viewReloader = ViewReloader()
    
    let files: [File?]
    @State var showAgrume: Bool = false
    @State var agrumeIndex: Int = 0
    
    var body: some View {
        SingleAxisGeometryReader { width in
            ForEach(Array(self.files.chunked(into: 2).enumerated()), id: \.offset) { (cIndex, chunk) in
                Grid(horizontalSpacing: 10) {
                    GridRow {
                        ForEach(Array(chunk.enumerated()), id: \.offset) { (index, file) in
                            RemoteImage(file?.thumbnailUrl, isBlurred: file?.isSensitive ?? false)
                                .frame(width: self.width(parentWidth: width, chunk: chunk), height: self.height())
                                .contentShape(Rectangle())
                                .gesture(TapGesture().onEnded({ _ in
                                    withAnimation {
                                        self.agrumeIndex = (cIndex * 2) + index
                                        self.showAgrume = true
                                        self.viewReloader.reloadView()
                                    }
                                }))
                        }
                    }
                    .frame(width: self.width(parentWidth: width, chunk: chunk), height: self.height())
                    .cornerRadius(11)
                }
                .id(width)
                .frame(maxWidth: .infinity)
            }
        }.fullScreenCover(isPresented: self.$showAgrume, content: {
            WrapperAgrumeView(urls: self.urls(), startIndex: self.agrumeIndex, isPresenting: self.$showAgrume)
                .clearBackground()
                .ignoresSafeArea()
        })
    }
    
    private func height() -> CGFloat {
        return self.files.count > 2 ? 150 : 300
    }
    
    private func width(parentWidth: CGFloat, chunk: [File?]) -> CGFloat {
        let containerWidth = parentWidth / CGFloat(chunk.count)
        if chunk.count < 2 {
            return containerWidth
        }

        let totalSpacing = 10 * (chunk.count - 1)
        return containerWidth - CGFloat(totalSpacing / chunk.count)
    }
    
    private func urls() -> [URL] {
        self.files.map { file in
            URL(string: file!.url!)!
        }
    }
}

struct WrapperAgrumeView: UIViewControllerRepresentable {

  private let urls: [URL]
  private let startIndex: Int
  @Binding private var binding: Bool

    public init(urls: [URL], startIndex: Int, isPresenting: Binding<Bool>) {
    self.urls = urls
        self.startIndex = startIndex
    self._binding = isPresenting
  }

  public func makeUIViewController(context: UIViewControllerRepresentableContext<WrapperAgrumeView>) -> UIViewController {
      let agrume = Agrume(urls: self.urls, startIndex: self.startIndex, background: .blurred(.regular))
    agrume.view.backgroundColor = .clear
    agrume.addSubviews()
    agrume.addOverlayView()
    agrume.didDismiss = {
          withAnimation {
            binding = false
          }
      }
    return agrume
  }

  public func updateUIViewController(_ uiViewController: UIViewController,
                                     context: UIViewControllerRepresentableContext<WrapperAgrumeView>) {
  }
}

#Preview {
    VStack {
        BetterNoteBodyGallery(files: [NoteModel.preview.renote!.files?.first!])
//        Spacer()
//        BetterNoteBodyGallery(files: [NoteModel.preview.renote!.files?.first!, NoteModel.preview.renote!.files?.first!, NoteModel.preview.renote!.files?.first!])
//        Spacer()
//        BetterNoteBodyGallery(files: NoteModel.preview.renote!.files!)
    }
}
