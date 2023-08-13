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
            TimelineHeader(selectedTab: self.$selectedTab)
        }
    }
}

#Preview {
    TimelineView()
}
