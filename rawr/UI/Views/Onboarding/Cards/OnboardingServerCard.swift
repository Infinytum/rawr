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
    
    @EnvironmentObject var context: ViewContext
    
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
                onServerSet(self.instanceHostname.lowercased())
            }
            Spacer()
            Button("Other Instance") {
                presentAlert = true
            }.alert("Other Instance", isPresented: $presentAlert, actions: {
                TextField("E.g. derg.social", text: $instanceHostname)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button("Set", action: {
                    onServerSet(self.instanceHostname.lowercased())
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please enter the hostname of your instance")
            }).padding(.top, 10).padding(.bottom, 30)
        }.frame(maxWidth: 500)
    }
    
    private func onServerSet(_ instance: String) {
        MisskeyKit.shared.changeInstance(instance: instance)
        RawrKeychain().instanceHostname = instance
        if RawrKeychain().instanceCredentials == nil {
            print("OnboardingServerCard: Creating new app on target instance")
            MisskeyKit.shared.app.create(
                name: "rawr.",
                description: "rawr. is the first native iOS app for Firefish.",
                permission: MisskeyPermission.allPermissions,
                callbackUrl: "https://derg.social/rawr.redirect"
            ) { app, error in
                guard let clientId = app?.id, let clientSecret = app?.secret else {
                    self.context.applicationError = ApplicationError(title: "Fetching API Token failed", message: error.explain())
                    print("OnboardingServerCard Error: API returned error while registering app: \(error!)")
                    return
                }
                
                RawrKeychain().instanceCredentials = InstanceCredentials(clientId: clientId, clientSecret: clientSecret)
                self.onContinue()
            }
        } else {
            print("OnboardingServerCard: Re-using existing instance app credentials")
            self.onContinue()
        }
    }
}

#Preview {
    WelcomeTemplate(appName: "rawr.") {
        OnboardingServerCard(){}
    }.environmentObject(ViewContext())
}
