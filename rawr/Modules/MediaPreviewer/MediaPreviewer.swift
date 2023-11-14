//
//  MediaPreviewer.swift
//  rawr.
//
//  Created by Nila on 13.11.2023.
//

import MisskeyKit
import SwiftUI

struct MediaPreviewer: View {
    
    let file: File
    
    var body: some View {
        if self.file.type!.starts(with: "image/gif") {
            MediaPreviewerGifRenderer(thumbnailUrl: self.file.thumbnailUrl, sensitive: self.file.isSensitive ?? false)
        } else if self.file.type!.starts(with: "image/") {
            MediaPreviewerImageRenderer(thumbnailUrl: self.file.thumbnailUrl, sensitive: self.file.isSensitive ?? false)
        } else if self.file.type!.starts(with: "video/") {
            MediaPreviewerVideoRenderer(thumbnailUrl: self.file.thumbnailUrl)
        } else {
            MediaPreviewerDefaultRenderer(fileType: self.file.type)
        }
    }
}

#Preview {
    MediaPreviewer(file: NoteModel.preview.renote!.files![0]!)
}
