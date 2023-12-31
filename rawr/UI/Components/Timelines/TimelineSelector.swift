//
//  TimelineSelector.swift
//  rawr.
//
//  Created by Nila on 28.08.2023.
//

import SwiftUI

struct TimelineSelector: View {
    
    @EnvironmentObject var context: ViewContext
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
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
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
                    }.foregroundColor(.primary.opacity(0.7))
                        .font(.system(size: 16))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.primary.opacity(0.7))
                        .padding(.leading, -5)
                }.padding(.top, -12)
            }
        }
    }
}

#Preview {
    TimelineSelector(selectedTab: .constant(0))
        .environmentObject(ViewContext())
}
