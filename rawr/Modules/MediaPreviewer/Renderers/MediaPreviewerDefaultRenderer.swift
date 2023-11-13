//
//  MediaPreviewerDefaultRenderer.swift
//  rawr.
//
//  Created by Nila on 13.11.2023.
//

import SwiftUI

struct MediaPreviewerDefaultRenderer: View {
    
    let fileType: String?
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.gray)
            .overlay(alignment: .center) {
                VStack {
                    Text("File")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                    Text(self.fileType ?? "Unknown Type")
                }.shadow(radius: 10)
            }
    }
}

#Preview {
    MediaPreviewerDefaultRenderer(fileType: nil)
}
