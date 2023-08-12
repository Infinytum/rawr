//
//  OnboardingMisskeyAuthModal.swift
//  Derg Social
//
//  Created by Nila on 11.08.2023.
//

import SwiftUI
import MisskeyKit

struct OnboardingMisskeyAuthModal: UIViewControllerRepresentable {
    let action: (_ success: Bool) -> Void
    let context: ViewContext
    
    public init(context: ViewContext, action: @escaping (_ success: Bool) -> Void) {
        self.context = context
        self.action = action
    }
    
    
    func makeUIViewController(context: Context) -> OnboardingMisskeyAuthModalController {
        let webloginViewController = OnboardingMisskeyAuthModalController()
        
        // Construct auth session
        // TODO: App Secret should be dynamic, but this is fine for development.
        MisskeyKit.shared.auth.startSession(appSecret: "YBzbr8X2bwzki0LqgEneuYfouvPpvbXz") { auth, error in
            guard let auth = auth, let token = auth.token, error == nil else {
                action(false)
                return
            }
            
            guard let url = URL(string: token.url) else {
                action(false)
                return
            }
            
            DispatchQueue.main.sync {
                webloginViewController.startSession(url: url)
            }
            
            Task { @MainActor in
                _ = try await webloginViewController.result()
                MisskeyKit.shared.auth.getAccessToken { auth, error in
                    guard let _ = auth else {
                        print(error ?? "Error was nil")
                        action(false)
                        return
                    }
                    
                    guard let apiKey = MisskeyKit.shared.auth.getAPIKey() else {
                        print("API Key was nil")
                        action(false)
                        return
                    }
                    
                    action(true)
                    RawrKeychain().apiKey = apiKey
                    withAnimation {
                        self.context.refreshContext()
                    }
                }
            }
        }
        return webloginViewController
    }
    
    func updateUIViewController(_ uiViewController: OnboardingMisskeyAuthModalController, context: Context) {
    }
    
}
