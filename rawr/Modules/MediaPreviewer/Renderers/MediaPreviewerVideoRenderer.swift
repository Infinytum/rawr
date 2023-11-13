//
//  MediaPreviewerVideoRenderer.swift
//  rawr.
//
//  Created by Nila on 13.11.2023.
//

import SwiftUI

struct MediaPreviewerVideoRenderer: View {
    
    let thumbnailUrl: String?
    
    var body: some View {
        VStack {
            if self.thumbnailUrl == nil {
                Rectangle()
                    .foregroundStyle(.gray)
                    .overlay(alignment: .center) {
                        VStack {
                            Text("Video")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                            Text("No Thumbnail")
                        }.shadow(radius: 10)
                    }
            } else {
                RemoteImage(self.thumbnailUrl)
                    .overlay(alignment: .center) {
                        VStack {
                            Image(systemName: "play.circle")
                                .font(.system(size: 45))
                                .shadow(radius: 10)
                        }
                    }
            }
        }
    }
}

#Preview {
    MediaPreviewerVideoRenderer(thumbnailUrl: "https://cdn.derg.social/calckey/7eae209b-405a-484b-ba1c-d94c0358266c.jpg")
}
