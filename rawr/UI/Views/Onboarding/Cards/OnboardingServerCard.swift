//
//  OnboardingServerCard.swift
//  Derg Social
//
//  Created by Nila on 11.08.2023.
//

import SwiftUI
import SwiftKit
import MisskeyKit

struct OnboardingServerCard: View {
    
    @State private var instanceHostname = ""
    @State private var presentAlert = false
    
    var onContinue: () -> Void
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("Instance Selection").fontWeight(.medium)
            }.font(.title2)
            Text("Please choose your instance or tap Other Instance if yours is not listed here.")
                .font(.body).fontWeight(.regular).multilineTextAlignment(.center).padding(.top, 1).padding(.horizontal)
            Spacer()
            HStack {
                Image(.dergSocialIcon).resizable().aspectRatio(contentMode: .fit).frame(height: 50).cornerRadius(11)
                VStack(alignment: .leading) {
                    Text("Derg Social").font(.title3)
                    Text("Developer Server").foregroundStyle(.gray)
                }.padding(.leading, 5)
            }.onTapGesture {
                self.instanceHostname = "derg.social"
                MisskeyKit.shared.changeInstance(instance: self.instanceHostname)
                RawrKeychain().instanceHostname = self.instanceHostname
                onContinue()
            }
            Spacer()
            Button("Other Instance") {
                presentAlert = true
            }.alert("Other Instance", isPresented: $presentAlert, actions: {
                TextField("E.g. derg.social", text: $instanceHostname)
                Button("Set", action: {
                    MisskeyKit.shared.changeInstance(instance: self.instanceHostname)
                    RawrKeychain().instanceHostname = self.instanceHostname
                    onContinue()
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please enter the hostname of your instance")
            }).padding(.top, 10).padding(.bottom, 30)
        }.frame(maxWidth: 500)
    }
}

#Preview {
    WelcomeTemplate(appName: "rawr.") {
        OnboardingServerCard(){}
    }
}
