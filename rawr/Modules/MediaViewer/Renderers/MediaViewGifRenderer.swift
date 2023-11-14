//
//  MediaViewGifRenderer.swift
//  rawr.
//
//  Created by Nila on 14.11.2023.
//

import Giffy
import SwiftUI

struct MediaViewGifRenderer: View {
    
    let url: String
    
    var body: some View {
        ZoomableView {
            AsyncGiffy(url: URL(string: self.url)!) { phase in
                switch phase {
                case .loading:
                    ProgressView()
                case .error:
                    Text("Failed to load GIF")
                case let .success(giffy):
                    giffy
                }
            }
        }
    }
}

#Preview {
    MediaViewGifRenderer(url: "https://media.tenor.com/cdzCl9477-UAAAAd/fish-i-am-just-a-fish.gif")
}
