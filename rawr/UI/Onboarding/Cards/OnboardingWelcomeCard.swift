//
//  OnboardingWelcomeCard.swift
//  Derg Social
//
//  Created by Nila on 11.08.2023.
//

import SwiftUI

struct OnboardingWelcomeCard: View {
    var onContinue: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("What is ").fontWeight(.medium) +
                Text(LocalizedStringKey("rawr.")).fontWeight(.medium)
            }.font(.title2)
            Group {
                Text(LocalizedStringKey("rawr.")).fontWeight(.bold) +
                Text(" is a fediverse client for iOS and iPadOS designed specifically for Firefish.")
                    .font(.body).fontWeight(.regular)
            }.multilineTextAlignment(.center).padding(.top, 1).padding(.horizontal)
            Text("The goal of this project is to provide a great iOS experience for Firefish users, without the drawbacks of a web app or using Mastodon apps.")
                .font(.body).fontWeight(.regular).multilineTextAlignment(.center).padding(.top, 20).padding(.horizontal)
            Spacer()
            Button("Continue") {onContinue()}.padding(.bottom, 30)
        }.frame(maxWidth: 500)
    }
}

#Preview {
    OnboardingWelcomeCard() {}
}
