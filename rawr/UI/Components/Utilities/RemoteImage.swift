//
//  RemoteImage.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import NetworkImage
import SwiftUI

struct RemoteImage: View {
    
    let url: String?
    
    init(_ url: String?) {
        self.url = url
    }
    
    var body: some View {
        NetworkImage(url: URL(string: self.url ?? "")) { image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .foregroundStyle(.primary.opacity(0.1))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .overlay(alignment: .center) { ProgressView() }
        } fallback: {
            Rectangle()
                .foregroundStyle(.primary.opacity(0.1))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fill)
        }
    }
}

#Preview {
    RemoteImage("https://cdn.derg.social/assets/icon.png")
        .frame(width: 100, height: 100)
}
