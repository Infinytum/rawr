//
//  TimelineSwitcherMenu.swift
//  rawr.
//
//  Created by Nila on 02.12.2023.
//

import SwiftUI

struct TimelineSwitcherMenu: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        Menu {
            Button("Home") {
                selectedTab = 0
            }
            Button("Local") {
                selectedTab = 1
            }
            Button("Global") {
                selectedTab = 2
            }
        } label: {
            VStack {
                HStack {
                    Group {
                        if (selectedTab == 0) {
                            Text("Home")
                        }
                        if (selectedTab == 1) {
                            Text("Local")
                        }
                        if (selectedTab == 2) {
                            Text("Global")
                        }
                    }.foregroundColor(.primary)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.leading, -3)
                }
            }.contentShape(Rectangle())
        }
    }
}

#Preview {
    TimelineSwitcherMenu(selectedTab: .constant(0))
}
