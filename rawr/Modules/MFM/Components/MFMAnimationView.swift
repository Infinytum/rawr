//
//  MFMAnimationView.swift
//  rawr.
//
//  Created by Nila on 26.11.2023.
//

import Foundation
import SwiftUI

enum MFMAnimation {
    case spin
    case spinX
    case spinY
    
    case jump
    
    case shake
}

struct MFMAnimationView<Content: View>: View {
    
    let animation: MFMAnimation
    var autoreverse: Bool = false
    var delay: TimeInterval = 0
    var loop: Int = 0
    var speed: Double = 0.5
    var reverse: Bool = false

    @ViewBuilder var view: Content
    
    @State private var spinState = 0.0
    @State private var jumpState = 0.0
    @State private var shakeState = -5.0
    
    var body: some View {
        switch self.animation {
        case .spin:
            VStack {
                view
            }
                .rotationEffect(.degrees(spinState), anchor: .center)
                .onAppear {
                    _ = Task.delayed(self.delay) {
                        withAnimation(self.defaultAnimation()) {
                            spinState = self.reverse ? -360 : 360
                        }
                    }
                }
        case .spinX:
            VStack {
                view
            }
                .rotation3DEffect(
                    .degrees(spinState),
                                          axis: (x: 1.0, y: 0.0, z: 0.0)
                )
                .onAppear {
                    _ = Task.delayed(self.delay) {
                        withAnimation(self.defaultAnimation()) {
                            spinState = self.reverse ? -360 : 360
                        }
                    }
                }
        case .spinY:
            VStack {
                view
            }
                .rotation3DEffect(
                    .degrees(spinState),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .onAppear {
                    _ = Task.delayed(self.delay) {
                        withAnimation(self.defaultAnimation()) {
                            spinState = self.reverse ? -360 : 360
                        }
                    }
                }
        case .jump:
            VStack {
                view
            }
                .offset(y: -self.jumpState)
                .onAppear {
                    _ = Task.delayed(self.delay) {
                        withAnimation(self.defaultAnimation(.easeInOut(duration: 1))) {
                            jumpState = 15
                        }
                    }
                }
        case .shake:
            VStack {
                view
            }
            .offset(x: self.shakeState)
            .onAppear {
                _ = Task.delayed(self.delay) {
                    withAnimation(self.defaultAnimation(.easeInOut(duration: 1))) {
                        shakeState = 5
                    }
                }
            }
        }
    }
    
    private func defaultAnimation(_ base: Animation = .linear(duration: 1)) -> Animation {
        var animation = base
            .speed(speed)
        
        if self.loop <= 0 {
            animation = animation
                .repeatForever(autoreverses: autoreverse)
        } else {
            animation = animation
                .repeatCount(self.loop, autoreverses: autoreverse)
        }
        
        return animation
    }
}

#Preview {
    MFMAnimationView(animation: .shake, autoreverse: true, speed: 4.0) {
        Text("Text")
    }
}
