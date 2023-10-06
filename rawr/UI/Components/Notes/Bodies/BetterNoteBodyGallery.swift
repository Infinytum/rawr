//
//  BetterNoteBodyGallery.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import NetworkImage
import MisskeyKit
import SwiftUI

struct BetterNoteBodyGallery: View {
    
    let files: [File?]
    
    var body: some View {
        SingleAxisGeometryReader { width in
            ForEach(Array(self.files.chunked(into: 2).enumerated()), id: \.offset) { (index, chunk) in
                Grid(horizontalSpacing: 10) {
                    GridRow {
                        ForEach(Array(chunk.enumerated()), id: \.offset) { (index, file) in
                            RemoteImage(file?.thumbnailUrl)
                        }
                    }
                    .frame(width: self.width(parentWidth: width, chunk: chunk), height: self.height())
                    .cornerRadius(11)
                }
                .id(width)
                .frame(maxWidth: .infinity)
            }
        }
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
}

#Preview {
    VStack {
        BetterNoteBodyGallery(files: [NoteModel.preview.renote!.files?.first!])
        Spacer()
        BetterNoteBodyGallery(files: [NoteModel.preview.renote!.files?.first!, NoteModel.preview.renote!.files?.first!, NoteModel.preview.renote!.files?.first!])
        Spacer()
        BetterNoteBodyGallery(files: NoteModel.preview.renote!.files!)
    }
}
