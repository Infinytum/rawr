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
                Timeline(timelineContext: HomeTimelineContext())
            }
            if selectedTab == 1 {
                Timeline(timelineContext: LocalTimelineContext())
            }
            if selectedTab == 2 {
                Timeline(timelineContext: GlobalTimelineContext())
            }
        }
    }
}

#Preview {
    TimelineView().environmentObject(ViewContext())
}
