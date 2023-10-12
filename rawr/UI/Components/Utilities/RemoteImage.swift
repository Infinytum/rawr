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
    
    @State private var isBlurred: Bool;
    
    init(_ url: String?) {
        self.url = url
        self.isBlurred = false
    }
    
    init(_ url: String?, isBlurred: Bool) {
        self.url = url
        self.isBlurred = isBlurred
    }
    
    var body: some View {
        NetworkImage(url: URL(string: self.url ?? "")) { image in
            image.resizable().aspectRatio(contentMode: .fill)
                .overlay(alignment: .center) {
                    if self.isBlurred {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("NSFW").padding(.top, 5)
                        }
                        .fluentBackground()
                        .onTapGesture {
                            self.isBlurred = false
                        }
                    }
                }
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
    RemoteImage("https://cdn.derg.social/assets/icon.png", isBlurred: true)
        .frame(width: 100, height: 100)
}
