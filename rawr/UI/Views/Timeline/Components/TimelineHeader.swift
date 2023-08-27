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
                NewNoteButton().padding(.trailing, 5)
                AntennaMenu()
            }
            VStack {
                TimelineSelector(selectedTab: self.$selectedTab)
            }
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    TimelineHeader(selectedTab: .constant(0))
        .environmentObject(ViewContext())
}
