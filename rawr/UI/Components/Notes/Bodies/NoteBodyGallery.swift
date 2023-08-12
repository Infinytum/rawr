//
//  NoteBodyGallery.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import NetworkImage
import MisskeyKit

struct NoteBodyGallery: View {
    @State private var isImagePresented = false
    @State private var presentedImage: Image? = nil
    @ObservedObject private var viewRefresher = ViewReloader()
    
    let files: [File?]

    var body: some View {
        LazyVGrid(columns: columns()) {
            ForEach(self.fileList(), id: \.id) { file in
                if file.thumbnailUrl == nil {
                    Rectangle()
                        .foregroundStyle(.primary.opacity(0.1))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped().cornerRadius(11)
                        .aspectRatio(1, contentMode: .fill)
                } else {
                    NetworkImage(url: URL(string: file.thumbnailUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fill)
                            .onTapGesture {
                                self.presentedImage = image
                                self.viewRefresher.reloadView()
                                self.isImagePresented = true
                            }
                    } placeholder: {
                        ProgressView()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                    } fallback: {
                        Rectangle()
                            .foregroundStyle(.primary.opacity(0.1))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).clipped().cornerRadius(11)
                }
            }
        }.fullScreenCover(isPresented: $isImagePresented) {
            ImageViewer(image: self.presentedImage!)
                .overlay(alignment: .topTrailing) {
                    Button {
                        self.isImagePresented = false
                        self.presentedImage = nil
                     } label: {
                         Image(systemName: "xmark")
                             .font(.headline)
                     }
                     .buttonStyle(.bordered)
                     .clipShape(Circle())
                     .padding()
                }
        }
    }
    
    func columns() -> [GridItem] {
        var cols: [GridItem] = []
        for _ in 0...(self.files.count / 2) {
            cols.append(GridItem(.flexible(minimum: 80)))
        }
        return cols
    }
    
    func fileList() -> [File] {
        self.files.filter { file in
            return file != nil
        }.map { file in
            return file!
        }
    }
}

#Preview {
    NoteBodyGallery(files: NoteModel.preview.renote?.files ?? [])
}
