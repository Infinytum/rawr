//
//  ImageViewer.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import SwiftUI

public struct ImageViewer: View {

    let image: Image

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    
    @State private var imageSize: CGSize = .zero
    
    @Binding var vSwipeOwned: Bool
    @Binding var hSwipeOwned: Bool
    
    @State var disableVSwipe = false
    @State var disableHSwipe = false
    @State var swipeDirection: Direction? = nil
    
    private var simulatedSize: CGSize {
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        return imageSize.applying(scaleTransform)
    }
    
    private var vDragPossible: Bool {
        simulatedSize.height > UIScreen.main.bounds.height
    }
    
    private var hDragPossible: Bool {
        simulatedSize.width > UIScreen.main.bounds.width
    }

    public init(image: Image, vSwipeOwned: Binding<Bool>, hSwipeOwned: Binding<Bool>) {
        self.image = image
        self._vSwipeOwned = vSwipeOwned
        self._hSwipeOwned = hSwipeOwned
    }
    
    public init(image: Image, vSwipeOwned: Bool, hSwipeOwned: Bool) {
        self.image = image
        self.disableHSwipe = !hSwipeOwned
        self.disableVSwipe = !vSwipeOwned
        self._vSwipeOwned = .constant(vSwipeOwned)
        self._hSwipeOwned = .constant(hSwipeOwned)
    }
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(x: offset.x, y: offset.y)
                    .gesture(makeDragGesture(size: proxy.size))
                    .gesture(makeMagnificationGesture(size: proxy.size))
                    .background() {
                        GeometryReader {
                            imProxy in
                            Color.clear
                                .onAppear {
                                    imageSize = imProxy.size
                                }
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }

    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value

                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
                
                if !disableVSwipe {
                    vSwipeOwned = self.vDragPossible
                }
                
                if !disableHSwipe {
                    hSwipeOwned = self.hDragPossible
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }

    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if disableVSwipe && disableHSwipe {
                    return
                }

                let deltaY = value.location.y - value.startLocation.y
                let deltaX = value.location.x - value.startLocation.x
                
                if swipeDirection == nil {
                    self.swipeDirection = abs(deltaX) > abs(deltaY) ? .horizontal : .vertical
                }

                if !vSwipeOwned && !hSwipeOwned {
                    return
                }

                var diff: CGPoint = .zero
                
                if vSwipeOwned && hSwipeOwned {
                    diff = CGPoint(
                        x: value.translation.width - lastTranslation.width,
                        y: value.translation.height - lastTranslation.height
                    )
                } else if vSwipeOwned {
                    diff.y = value.translation.height - lastTranslation.height
                } else {
                    diff.x = value.translation.width - lastTranslation.width
                }
                
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }

    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX: CGFloat = (simulatedSize.width - size.width) / 2
        let maxOffsetY: CGFloat = max((simulatedSize.height - size.height) / 2, 0)
        
        var newOffsetX = offset.x
        var newOffsetY = offset.y

        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }

        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
}

#Preview {
    @State var vSwipeOwnedChild = false
    @State var hSwipeOwnedChild = false
    @State var ownVSwipe: Bool? = true
    return ImageViewer(
        image: .init(.dergSocialIcon),
        vSwipeOwned: $vSwipeOwnedChild,
        hSwipeOwned: $hSwipeOwnedChild
    )
}
