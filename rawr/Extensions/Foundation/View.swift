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
