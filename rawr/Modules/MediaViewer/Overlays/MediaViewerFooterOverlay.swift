//
//  MediaViewerFooterOverlay.swift
//  rawr.
//
//  Created by Nila on 12.11.2023.
//

import SwiftUI

struct MediaViewerFooterOverlay: View {
    
    let comment: String
    
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text(self.comment)
                        .font(.system(size: 14))
                    Spacer()
                }
                .overlay(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            contentSize = geo.size
                        }
                    }
                )
            }
            .frame(maxHeight: min(contentSize.height, 150))
        }
        .padding(.all, 10)
        .background(.thinMaterial)
    }
}

#Preview {
    MediaViewerFooterOverlay(comment: "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum")
}
