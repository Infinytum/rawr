//
//  HashtagTimelineView.swift
//  rawr.
//
//  Created by Nila on 24.08.2023.
//

import SwiftUI
import SwiftKit

struct HashtagTimelineView: View {
    
    let hashtag: String
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                Timeline(timelineContext: HashtagTimelineContext(self.hashtag))
                    .padding(.top, 60)
                Spacer()
            }
            HashtagTimelineHeader(hashtag: self.hashtag).background(.thinMaterial)
        }
    }
}

#Preview {
    VStack {
        HStack {
            Spacer()
        }
        Spacer()
    }.popover(isPresented: .constant(true)) {
        HashtagTimelineView(hashtag: "dragons")
    }.environmentObject(ViewContext()).background(.red)
}
