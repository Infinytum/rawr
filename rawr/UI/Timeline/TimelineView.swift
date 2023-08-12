//
//  TimelineView.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI

struct TimelineView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            if selectedTab == 0 {
                Timeline(timelineContext: TimelineContext(timelineType: .HOME)).padding(.top, 55)
            }
            if selectedTab == 1 {
                Timeline(timelineContext: TimelineContext(timelineType: .LOCAL)).padding(.top, 55)
            }
            if selectedTab == 2 {
                Timeline(timelineContext: TimelineContext(timelineType: .GLOBAL)).padding(.top, 55)
            }

            ZStack {
                HStack(alignment: .center) {
                    ProfileSwitcher()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 10)
                        .padding(.top, 5)
                        .padding(.bottom, -5)
                    Spacer()
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                        .padding(.top, 5)
                }
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
                        Text("Derg Social").font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
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
                                .padding(.top, -11)
                                .padding(.bottom, -10)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.primary.opacity(0.7))
                                .padding(.leading, -5)
                        }.padding(.leading, 10).padding(.top, -5).padding(.bottom, -5)
                    }
                }
            }.padding(.horizontal).padding(.bottom).background(.thinMaterial)
        }
    }
}

#Preview {
    TimelineView()
}
