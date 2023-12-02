//
//  ListTimelineView.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import MisskeyKit
import SwiftUI

struct ListTimelineView: View {
    
    let list: ListModel
    
    var body: some View {
        VStack {
            Timeline(timelineContext: ListTimelineContext(self.list.id!))
        }
        .fluentBackground()
        .safeAreaInset(edge: .top, spacing: 0) {
            BetterAppHeader(isNavLink: true) {
                AppHeaderSimpleBody {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary.opacity(0.7))
                        Text(self.list.name!)
                            .foregroundColor(.primary.opacity(0.7))
                            .padding(.leading, -5)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ListTimelineView(list: .preview)
}
