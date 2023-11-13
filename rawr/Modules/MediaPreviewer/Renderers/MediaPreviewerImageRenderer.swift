//
//  MediaPreviewerImageRenderer.swift
//  rawr.
//
//  Created by Nila on 13.11.2023.
//

import SwiftUI

struct MediaPreviewerImageRenderer: View {
    
    let thumbnailUrl: String?
    @State var sensitive: Bool
    
    var body: some View {
        VStack {
            if self.thumbnailUrl == nil {
                Rectangle()
                    .foregroundStyle(.gray)
                    .overlay(alignment: .center) {
                        VStack {
                            Text("\(self.sensitive ? "NSFW " : "")Image")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                            Text("No Thumbnail")
                        }.shadow(radius: 10)
                    }
            } else {
                RemoteImage(self.thumbnailUrl, isBlurred: self.sensitive)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
            MediaPreviewerImageRenderer(thumbnailUrl: nil, sensitive: true)
        Spacer()
    }
}
