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
        MisskeyKit.shared.auth.startSession(appSecret: RawrKeychain().instanceCredentials?.clientSecret ?? "") { auth, error in
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
                        self.context.applicationError = ApplicationError(title: "Fetching Access Token failed", message: error.explain())
                        print("OnboardingMisskeyAuthModel Error: Fetching AccessToken failed: \(error!)")
                        action(false)
                        return
                    }
                    
                    guard let apiKey = MisskeyKit.shared.auth.getAPIKey() else {
                        self.context.applicationError = ApplicationError(title: "Fetching API Token failed", message: error.explain())
                        print("OnboardingMisskeyAuthModel Error: API Token was nil: \(error!)")
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
