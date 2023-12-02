//
//  User.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import MisskeyKit
import SwiftUI

struct User: View {
    
    let user: UserModel
    
    @State private var selectedScope: UserTimelineContext.timelineScope = .notes

    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        BetterUserHeader(user: self.user)
                        Picker("Scope", selection: self.$selectedScope) {
                            ForEach(UserTimelineContext.timelineScope.allCases) {scope in
                                Text(scope.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    .fluentBackground()
                        
                    Timeline(timelineContext: UserTimelineContext(self.user.id, self.selectedScope))
                        .frame(maxHeight: proxy.size.height)
                        .padding(.top, -10)
                }
            }
        }
        .fluentBackground()
        .safeAreaInset(edge: .top, spacing: 0) {
            AppHeader(isNavLink: true) {
                Text("User Profile")
            }
        }
    }
}

#Preview {
    VStack {
        NavigationStack {
            User(user: .preview).environmentObject(ViewContext())
        }
    }
}
