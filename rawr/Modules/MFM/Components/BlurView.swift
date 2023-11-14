//
//  BlurText.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import SwiftUI

class BlurViewContext: ObservableObject {
    @Published var showBlurredText: Bool = false
}

struct BlurView<Content: View>: View {
    
    @EnvironmentObject var context: BlurViewContext
    
    @ViewBuilder var view: Content
    
    var body: some View {
        view
            .blur(radius: self.context.showBlurredText ? 0 : 6)
            .onTapGesture {
                withAnimation {
                    self.context.showBlurredText.toggle()
                }
            }
    }
}

#Preview {
    BlurView {
        Text("Blurred Text")
    }.environmentObject(BlurViewContext())
}
