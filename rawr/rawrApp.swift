//
//  rawrApp.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import SwiftUI

@main
struct rawrApp: App {
    let context: ViewContext = ViewContext()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(self.context)
        }
    }
}
