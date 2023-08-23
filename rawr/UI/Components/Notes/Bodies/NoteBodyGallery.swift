//
//  NoteBodyGallery.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import NetworkImage
import MisskeyKit

enum Direction {
    case vertical
    case horizontal
}
extension Array where Element: Equatable {
    mutating func removeAll(_ element: Element) {
        removeAll(where: {$0 == element})
    }
}

struct NoteBodyGallery: View {
    @State private var isImagePresented = false
    private var presentedImage: Image {
        images[presentedImageIndex!]
    }
    @State private var images: [Image] = []
    @State private var presentedImageIndex: Int? = nil
    
    @State private var lastTranslation: CGSize = .zero
    @State private var offset: CGPoint = .zero
    
    @State private var swipeDirection: Direction? = nil
    
    @ObservedObject private var viewRefresher = ViewReloader()
    @State private var vSwipeChildOwned = false
    @State private var hSwipeChildOwned = false
    
    @State private var menusOffset: CGFloat = .zero
    
    @State private var nsfwDismissed: [String] = []
    
    let files: [File?]

    var body: some View {
        LazyVGrid(columns: columns()) {
            ForEach(Array(self.fileList().enumerated()), id: \.1.id) { (index, file) in
                if file.thumbnailUrl == nil {
                    Rectangle()
                        .foregroundStyle(.primary.opacity(0.1))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .aspectRatio(1, contentMode: .fill)
                } else {
                    NetworkImage(url: URL(string: file.thumbnailUrl!)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    if file.isSensitive ?? false && !nsfwDismissed.contains(file.id!) {
                                        withAnimation{
                                            nsfwDismissed.append(file.id!)
                                        }
                                    } else {
                                        self.viewRefresher.reloadView()
                                        self.isImagePresented = true
                                        self.presentedImageIndex = index
                                    }
                                }
                                .clipped()
                                .background(alignment: .center){
                                    image
                                        .resizable()
                                        .blur(radius: 15)
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                }
                                .onAppear {
                                    images.append(image)
                                }
                                .blur(radius: file.isSensitive ?? false && !nsfwDismissed.contains(file.id!) ? 15 : 0)
                                .overlay {
                                    if file.isSensitive ?? false && !nsfwDismissed.contains(file.id!) {
                                        VStack {
                                            Image(systemName: "exclamationmark.triangle")
                                            Text("NSFW")
                                        }
                                        .foregroundStyle(.white)
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    if file.isSensitive ?? false && nsfwDismissed.contains(file.id!) {
                                        Button {
                                            withAnimation {
                                                nsfwDismissed.removeAll(file.id!)
                                            }
                                        } label: {
                                            Image(systemName: "eye.slash")
                                        }
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            .gray
                                                .opacity(0.75)
                                        )
                                        .clipShape(Circle())
                                        .padding([.top, .trailing],5)
                                    }
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
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                }
            }
        }
        .fullScreenCover(isPresented: self.$isImagePresented) {
            ZStack {
                GeometryReader {viewerContainserSize in
                    if presentedImageIndex!-1 >= 0 {
                        ImageViewer(
                            image: images[presentedImageIndex!-1],
                            vSwipeOwned: false,
                            hSwipeOwned: false
                        )
                        .offset(x:offset.x - UIScreen.main.bounds.width, y:0)
                    }
                    ImageViewer(
                        image: self.presentedImage,
                        vSwipeOwned: $vSwipeChildOwned,
                        hSwipeOwned: $hSwipeChildOwned
                    )
                    .offset(x:offset.x, y:offset.y)
                    .onTapGesture {loc in
                        if loc.x < viewerContainserSize.size.width &&
                            loc.x > viewerContainserSize.size.width - 30 &&
                            images.count - 1 > presentedImageIndex! + 1 {
                            presentedImageIndex! += 1
                        } else if loc.x < 30 &&
                                    loc.x > 0 {
                            presentedImageIndex! -= 1
                        } else {
                            withAnimation {
                                menusOffset = menusOffset == 60 ? 0 : 60
                            }
                        }
                    }
                    if images.count - 1 >= presentedImageIndex! + 1 {
                        ImageViewer(
                            image: images[presentedImageIndex!+1],
                            vSwipeOwned: false,
                            hSwipeOwned: false
                        )
                        .offset(x: offset.x + UIScreen.main.bounds.width, y:0)
                    }
                }
            }
                .simultaneousGesture(dragToDismiss)
                .simultaneousGesture(dragToChangeImage)
                .background(.black)
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
                                            ImageRenderer(content: presentedImage).uiImage!, nil, nil, nil)
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
        withAnimation(.easeOut(duration: 0.3)) {
            offset.y = 300
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isImagePresented = false
            self.presentedImageIndex = nil
            offset = .zero
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

    var dragToDismiss: some Gesture {
        DragGesture()
            .onChanged() {value in
                let deltaY = value.location.y - value.startLocation.y
                let deltaX = value.location.x - value.startLocation.x
                
                if swipeDirection == nil {
                    self.swipeDirection = abs(deltaX) > abs(deltaY) ? .horizontal : .vertical
                }
                
                if swipeDirection != .vertical ||
                   vSwipeChildOwned {
                    return
                }
                
                if value.translation.height > 0 {
                    let diff = CGPoint(
                        x: 0,
                        y: value.translation.height - lastTranslation.height
                    )
                    
                    offset = .init(x: 0, y: offset.y + diff.y)
                    lastTranslation = value.translation
                }
            }
            .onEnded() {value in
                if(swipeDirection != .vertical){
                    return
                }
                
                if value.predictedEndTranslation.height > 150 {
                    hideImage()
                } else {
                    withAnimation {
                        offset.y = 0.0
                    }
                }
                lastTranslation = .zero
                swipeDirection = nil
            }
    }
    
    var dragToChangeImage: some Gesture {
        DragGesture()
            .onChanged { value in
                let goingRight = value.translation.width < 0

                if swipeDirection != .horizontal ||
                    vSwipeChildOwned {
                    return
                }
                
                if (goingRight && images.count > presentedImageIndex! + 1) ||
                    (!goingRight && presentedImageIndex! > 0) {
                    offset = .init(x: value.translation.width, y: 0)
                } else {
                    offset = .init(x: value.translation.width / 2, y: 0)
                }
            }
            .onEnded { value in
                if swipeDirection != .horizontal {
                    return
                }
                
                let goingRight = value.predictedEndTranslation.width < 0
                if abs(value.predictedEndTranslation.width) < UIScreen.main.bounds.width / 2 {
                    withAnimation {
                        offset = .zero
                    }
                } else if (goingRight && images.count > presentedImageIndex! + 1) ||
                        (!goingRight && presentedImageIndex! > 0) {
                    if goingRight {
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset.x = -UIScreen.main.bounds.width
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            presentedImageIndex! += 1
                            offset = .zero
                        }
                        
                    } else {
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset.x = UIScreen.main.bounds.width
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            presentedImageIndex! -= 1
                            offset = .zero
                        }
                    }
                } else {
                    withAnimation {
                        offset = .zero
                    }
                }
                lastTranslation = .zero
                swipeDirection = nil
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
    return NoteBodyGallery(files: NoteModel.preview.renote?.files ?? [])
}
