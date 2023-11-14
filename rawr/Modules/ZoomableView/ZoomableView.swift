//
//  ZoomableView.swift
//  rawr.
//
//  Created by Nila on 14.11.2023.
//

import SwiftUI

fileprivate struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ZoomableView<Content: View>: View {
    
    @ViewBuilder var view: Content
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @State private var proxySize: CGSize = .zero
    
    @State var panGestureMask: GestureMask = .subviews
    @State private var panOffsetSaved: CGSize = .zero
    @State private var panOffsetCurrent: CGSize = .zero
    
    var panOffset: CGSize {
        CGSize(width: panOffsetSaved.width + panOffsetCurrent.width, height: panOffsetSaved.height + panOffsetCurrent.height)
    }
    
    var body: some View {
        SingleAxisGeometryReader { width in
            self.view
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: width)
                .background(GeometryReader {proxy in
                    Color.clear
                              .preference(key: SizePreferenceKey.self, value: proxy.size)
                })
                .onPreferenceChange(SizePreferenceKey.self) { newSize in
                    self.proxySize = newSize
                }
                .scaleEffect(currentZoom + totalZoom)
                .offset(self.panOffset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentZoom = (value - 1)*1.3
                        }
                        .onEnded { value in
                            withAnimation {
                                totalZoom = max(min(totalZoom + currentZoom, 3.0), 1.0)
                                currentZoom = 0
                                self.fixPan(originalSize: self.proxySize)
                            }
                        }
                )
                .highPriorityGesture(TapGesture(count: 2)
                    .onEnded({ _ in
                        withAnimation {
                            if self.totalZoom == 1.0 {
                                self.totalZoom = 2.0
                            } else {
                                self.totalZoom = 1.0
                            }
                            self.fixPan(originalSize: self.proxySize)
                        }
                    })
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if self.totalZoom == 1.0 {
                                return;
                            }
                            
                            self.panOffsetCurrent = gesture.translation
                        }
                        .onEnded({ gesture in
                            if self.totalZoom == 1.0 {
                                return;
                            }
                            
                            self.panOffsetSaved = CGSize(width: self.panOffsetSaved.width + gesture.translation.width, height: self.panOffsetSaved.height + gesture.translation.height)
                            self.panOffsetCurrent = .zero
                            self.fixPan(originalSize: self.proxySize)
                        }),
                    including: self.panGestureMask
                )
        }
    }
    
    private func fixPan(originalSize: CGSize) {
        self.panGestureMask = self.totalZoom == 1.0 ? .subviews : .all
        
        withAnimation {
            if self.totalZoom == 1.0 {
                self.panOffsetSaved = .zero
            } else {
                let maxWidthOffset = ((originalSize.width * self.totalZoom) - originalSize.width) / (2 * self.totalZoom) * self.totalZoom
                let maxHeightOffset = (((originalSize.height * self.totalZoom) - originalSize.height) / (2 * self.totalZoom) * self.totalZoom)
                self.panOffsetSaved.width = max(min(maxWidthOffset, self.panOffsetSaved.width), -maxWidthOffset)
                self.panOffsetSaved.height = max(min(maxHeightOffset, self.panOffsetSaved.height), -maxHeightOffset)
            }
        }
    }
}

#Preview {
    ZoomableView {
        RemoteImage("https://user-images.githubusercontent.com/80097964/278994464-ade75394-fed9-4656-a8f4-93cd21254dd3.jpeg")
    }.border(.red)
}
