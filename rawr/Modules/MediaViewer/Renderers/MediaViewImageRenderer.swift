//
//  MediaViewImageRenderer.swift
//  rawr.
//
//  Created by Nila on 12.11.2023.
//

import SwiftUI

struct MediaViewImageRenderer: View {
    
    let url: String
    
    var body: some View {
        ZoomableView {
            RemoteImage(self.url)
        }
    }
}

#Preview {
    MediaViewImageRenderer(url: "https://user-images.githubusercontent.com/80097964/278994464-ade75394-fed9-4656-a8f4-93cd21254dd3.jpeg")
}
