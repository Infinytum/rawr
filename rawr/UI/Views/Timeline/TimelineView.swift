//
//  BetterTimelineView.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

struct TimelineView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
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
