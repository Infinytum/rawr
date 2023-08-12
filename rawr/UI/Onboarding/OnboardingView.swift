//
//  OnboardingView.swift
//  Derg Social
//
//  Created by Nila on 11.08.2023.
//

import SwiftUI
import SwiftKit

struct OnboardingView: View {

    @ObservedObject var context: ViewContext
    @State private var selection = 0
    
    var body: some View {
        WelcomeTemplate(appName: "rawr.", slogan: "", image: AnyView(Image(.appIcon).resizable().scaledToFit().cornerRadius(11))) {
            if (selection == 0) {
                OnboardingWelcomeCard {
                    withAnimation {
                        selection = 1
                    }
                }.transition(.backslide).frame(maxWidth: 500)
            }
            if (selection == 1) {
                OnboardingServerCard {
                    withAnimation {
                        selection = 2
                    }
                }.transition(.backslide)
            }
            if (selection == 2) {
                OnboardingConnectCard(context: self.context).transition(.backslide)
            }
        }
    }
}

#Preview {
    OnboardingView(context: ViewContext())
}
