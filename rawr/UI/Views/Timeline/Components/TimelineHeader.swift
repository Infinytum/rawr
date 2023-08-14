//
//  TimelineHeader.swift
//  rawr
//
//  Created by Nila on 13.08.2023.
//

import SwiftUI

struct TimelineHeader: View {
    
    @EnvironmentObject var context: ViewContext
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                ProfileSwitcher()
                    .frame(width: 40, height: 40)
                Spacer()
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 20))
            }
            VStack {
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
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    TimelineHeader(selectedTab: .constant(0))
}
