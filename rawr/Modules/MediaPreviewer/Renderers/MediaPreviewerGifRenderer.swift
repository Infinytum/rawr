//
//  MediaPreviewerGifRenderer.swift
//  rawr.
//
//  Created by Nila on 14.11.2023.
//

import Giffy
import SwiftUI

struct MediaPreviewerGifRenderer: View {
    
    let thumbnailUrl: String?
    @State var sensitive: Bool
    
    var body: some View {
        VStack {
            if self.thumbnailUrl == nil {
                Rectangle()
                    .foregroundStyle(.gray)
                    .overlay(alignment: .center) {
                        VStack {
                            Text("\(self.sensitive ? "NSFW " : "")GIF")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                            Text("No Thumbnail")
                        }.shadow(radius: 10)
                    }
            } else {
                AsyncGiffy(url: URL(string: self.thumbnailUrl!)!) { phase in
                    switch phase {
                    case .loading:
                        ProgressView()
                    case .error:
                        Text("Failed to load GIF")
                    case let .success(giffy):
                        giffy
                        .overlay(alignment: .center) {
                            if self.sensitive {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("NSFW").padding(.top, 5)
                                }
                                .fluentBackground()
                                .onTapGesture {
                                    self.sensitive = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        MediaPreviewerGifRenderer(thumbnailUrl: "https://media.tenor.com/cdzCl9477-UAAAAd/fish-i-am-just-a-fish.gif", sensitive: true)
        Spacer()
    }
}
