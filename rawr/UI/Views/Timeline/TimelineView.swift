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
                Timeline(timelineContext: HomeTimelineContext()).padding(.top, 55)
            }
            if selectedTab == 1 {
                Timeline(timelineContext: LocalTimelineContext()).padding(.top, 55)
            }
            if selectedTab == 2 {
                Timeline(timelineContext: GlobalTimelineContext()).padding(.top, 55)
            }
            TimelineHeader(selectedTab: self.$selectedTab)
        }
    }
}

#Preview {
    TimelineView().environmentObject(ViewContext())
}
