//
//  BetterTimelineView.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

struct BetterTimelineView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            AppHeader {
                HStack {
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
                            }.padding(.top, -12)
                        }
                    }
                }
            }
            Spacer()
            Group {
                if selectedTab == 0 {
                    BetterTimeline(timelineContext: HomeTimelineContext())
                }
                if selectedTab == 1 {
                    BetterTimeline(timelineContext: LocalTimelineContext())
                }
                if selectedTab == 2 {
                    BetterTimeline(timelineContext: GlobalTimelineContext())
                }
            }
            .shadow(color: .black.opacity(0.15), radius: 10)
            Spacer()
        }
    }
}

#Preview {
    BetterTimelineView().environmentObject(ViewContext())
}
