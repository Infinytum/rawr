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
        VStack {
            Timeline(timelineContext: HashtagTimelineContext(self.hashtag))
        }
        .fluentBackground()
        .safeAreaInset(edge: .top, spacing: 0) {
            AppHeader(isNavLink: true) {
                Text("#" + self.hashtag)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HashtagTimelineView(hashtag: "dragons").environmentObject(ViewContext())
}
