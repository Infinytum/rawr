//
//  BetterTimelineView.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

struct TimelineView: View {
    
    @AppStorage("TimelineView.selectedTab") var selectedTab: Int = 0
    
    var body: some View {
        VStack {
            if selectedTab == 0 {
                Timeline(timelineContext: HomeTimelineContext())
            }
            if selectedTab == 1 {
                Timeline(timelineContext: LocalTimelineContext())
            }
            if selectedTab == 2 {
                Timeline(timelineContext: GlobalTimelineContext())
            }
        }
        .safeAreaInset(edge: .top, spacing: 0, content: {
            BetterAppHeader {
                AppHeaderSimpleBody {
                    TimelineSwitcherMenu(selectedTab: self.$selectedTab)
                        .padding(.top, -11)
                }
                Spacer()
                AntennaMenu()
                    .padding(.trailing, 10)
                UserListMenu()
            }
        })
    }
}

#Preview {
    TimelineView().environmentObject(ViewContext())
}
