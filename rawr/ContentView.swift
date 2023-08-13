//
//  ContentView.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import SwiftUI
import MisskeyKit

struct ContentView: View {
    
    @ObservedObject var context: ViewContext
    
    var body: some View {
        VStack {
            if context.loggedIn {
                if context.applicationReady {
                    MainView(context: context)
                } else {
                    Spacer()
                    Text("Contacting your instance")
                    ProgressView()
                    Spacer()
                }
            } else {
                OnboardingView(context: context).transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView(context: ViewContext())
}
