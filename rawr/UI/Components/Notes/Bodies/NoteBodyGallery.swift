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

struct NoteBodyGallery: View {
    
    @ObservedObject var viewReloader = ViewReloader()
    
    let files: [File?]
    @State var showMediaViewer: Bool = false
    @State var mediaViewerIndex: Int = 0
    
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
                                        self.mediaViewerIndex = (cIndex * 2) + index
                                        self.showMediaViewer = true
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
        }.fullScreenCover(isPresented: self.$showMediaViewer, content: {
            MediaViewer(files: self.files, index: self.mediaViewerIndex)
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

#Preview {
    VStack {
        NoteBodyGallery(files: NoteModel.preview.renote!.files!)
    }
}
