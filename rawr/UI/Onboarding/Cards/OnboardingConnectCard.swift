//
//  OnboardingConnectCard.swift
//  Derg Social
//
//  Created by Nila on 11.08.2023.
//

import SwiftUI

struct OnboardingConnectCard: View {
    
    @EnvironmentObject var context: ViewContext
    @State var showModal = false
    @State var showSpinner = false
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("Connecting your Account").fontWeight(.medium)
            }.font(.title2)
            Group {
                Text("You are about to connect your account to ") + Text(LocalizedStringKey("rawr.")).fontWeight(.bold)
                Text(LocalizedStringKey("rawr.")).fontWeight(.bold) + Text(" communicates directly with your chosen instance. Infinytum cannot see or access your data.")
            }.multilineTextAlignment(.center).padding(.top, 1).padding(.horizontal)
            Spacer()
            if showSpinner {
                ProgressView().padding(.bottom, 27).padding(.top, 10)
            } else {
                Button(action: {
                    self.showModal = true
                    self.showSpinner = true
                }) {
                    HStack {
                        Text("Connect to rawr.")
                            .foregroundStyle(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding(.horizontal, 60)
                    .padding(.vertical, 10)
                }.background(.blue).cornerRadius(11).padding(.bottom, 30)
            }
        }.frame(maxWidth: 500).sheet(isPresented: $showModal, content: {
            OnboardingMisskeyAuthModal(context: self.context){ success in
                showModal = false
                showSpinner = false
            }.ignoresSafeArea()
        })
    }
}

#Preview {
    VStack {
        OnboardingConnectCard()
    }.background(.gray.opacity(0.2)).cornerRadius(11).padding().frame(maxHeight: 300)
    
}
