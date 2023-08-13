//
//  ContentView.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import SwiftUI
import MisskeyKit

struct ContentView: View {
    
    @EnvironmentObject var context: ViewContext
    
    var body: some View {
        VStack {
            if context.loggedIn {
                if context.applicationReady {
                    MainView()
                } else {
                    Spacer()
                    Text("Contacting your instance")
                    ProgressView()
                    Spacer()
                }
            } else {
                OnboardingView().transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
