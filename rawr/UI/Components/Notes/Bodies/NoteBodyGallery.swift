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
    @State private var presentedImageIndex: Int? = nil
    
    @State private var lastTranslation: CGSize = .zero
    @State private var offset: CGPoint = .zero
    
    @State private var ignoreSwipe: Bool? = nil
    
    @ObservedObject private var viewRefresher = ViewReloader()
    @State private var vDraggable = false
    
    @State private var menusOffset: CGFloat = .zero
    
    let files: [File?]

    var body: some View {
        LazyVGrid(columns: columns()) {
            ForEach(Array(self.fileList().enumerated()), id: \.1.id) { (index, file) in
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
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .background(image.blur(radius: 15))
                            .onTapGesture {
                                self.presentedImage = image
                                self.viewRefresher.reloadView()
                                self.isImagePresented = true
                                self.presentedImageIndex = index
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
                ImageViewer(
                    image: self.presentedImage!,
                    vDraggable: $vDraggable,
                    ownSwipe: $ignoreSwipe
                )
                .offset(x:0, y:offset.y)
                .background(.black)
                .onTapGesture {
                    withAnimation {
                        menusOffset = menusOffset == 60 ? 0 : 60
                    }
                }
            }
            .simultaneousGesture(dragToDismiss)
            .background(TransparentBackground().ignoresSafeArea())
                .opacity(1.0 - abs(offset.y) / 300.0)
                .overlay() {
                    GeometryReader(){proxy in
                        VStack() {
                            HStack() {
                                Button {
                                    hideImage()
                                } label: {
                                    Image(systemName: "chevron.left")
                                    Text("Backsies")
                                }
                                .foregroundStyle(.white)
                                .bold()
                                .underline()
                                
                                Spacer()
                                
                                Menu() {
                                    Button() {
                                        
                                        UIImageWriteToSavedPhotosAlbum(
                                            ImageRenderer(content: presentedImage!).uiImage!, nil, nil, nil)
                                    } label: {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("Save image")
                                    }
                                } label: {
                                    Image(systemName:"ellipsis.circle")
                                }
                            }
                            .frame(height: 60)
                            .background(.black.opacity(0.7))
                            .offset(x:0, y: -menusOffset)
                            
                            Spacer()
                            HStack() {
                                Text("Image \(presentedImageIndex!+1) of \(files.count)")
                            }
                            .frame(width: proxy.size.width, height: 60)
                            .background(.black.opacity(0.7))
                            .offset(x:0, y: menusOffset)
                            .foregroundStyle(.white)
                        }
                    }
                    .opacity(0.7 - abs(offset.y) / 300.0)
                }
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
                let deltaY = value.location.y - value.startLocation.y
                let deltaX = value.location.x - value.startLocation.x
                
                if ignoreSwipe == nil {
                    self.ignoreSwipe = abs(deltaX) > abs(deltaY)
                }
                
                if ignoreSwipe! {
                    return
                }
                
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
                ignoreSwipe = nil
            }
    }
}

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
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
