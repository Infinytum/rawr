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
    
    @State private var lastTranslation: CGSize = .zero
    @State private var offset: CGPoint = .zero
    
    @ObservedObject private var viewRefresher = ViewReloader()
    @State private var vDraggable = false
    
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
        }
        .fullScreenCover(isPresented: self.$isImagePresented) {
            ZStack {
                ImageViewer(image: self.presentedImage!, vDraggable: $vDraggable)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                hideImage()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.headline)
                            }
                                .buttonStyle(.bordered)
                                .clipShape(Circle())
                                .padding()
                        }
                        .offset(x:0, y:offset.y)

            }
            .simultaneousGesture(dragToDismiss)
                .background(TransparentBackground())
                .opacity(1.0 - abs(offset.y) / 300.0)
            }
    }
    
    private func hideImage () {
        self.isImagePresented = false
        self.presentedImage = nil
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
    
    var dragToDismiss: some Gesture {
        DragGesture()
            .onChanged() {value in
                if value.translation.height > 0 {
                    let diff = CGPoint(
                        x: 0,
                        y: vDraggable ? 0 : value.translation.height - lastTranslation.height
                    )
                    
                    offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                    lastTranslation = value.translation
                }
            }
            .onEnded() {_ in
                print(offset.y)
                if abs(offset.y) > 150 {
                    hideImage()
                    offset = .zero
                } else {
                    withAnimation {
                        offset.y = 0.0
                    }
                }
                lastTranslation = .zero
            }
    }
}

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


#Preview {
    NoteBodyGallery(files: NoteModel.preview.renote?.files ?? [])
}
