//
//  View.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    public func fluentBackground(_ material: Material = .regularMaterial, fullscreen: Bool = true) -> some View {
        ZStack {
            GeometryReader { geometry in
               Rectangle()
                   .fill(material)
                   .edgesIgnoringSafeArea(.all)
                   .frame(maxWidth: geometry.size.width,
                            maxHeight: geometry.size.height)
             }
            if fullscreen {
                self
            } else {
                self.layoutPriority(1)
            }
        }.clearBackground()
    }
    
    /// Make any view's background fully transparent
    ///
    /// - Parameter clear: Will remove background when set to true
    @ViewBuilder
    public func clearBackground(_ clear: Bool = true) -> some View {
        if clear {
            self.background(ClearBlackground().ignoresSafeArea())
        } else {
            self
        }
    }
    
    
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
    
    func fullWidth() -> some View {
        self.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
    }
}


/// Background View that has a clear background
fileprivate struct ClearBlackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

fileprivate struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
    
    typealias Value = CGPoint

}

fileprivate struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint
    
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}
