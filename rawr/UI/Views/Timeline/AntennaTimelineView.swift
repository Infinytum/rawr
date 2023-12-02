//
//  AntennaTimelineView.swift
//  rawr.
//
//  Created by Nila on 24.08.2023.
//

import MisskeyKit
import SwiftUI

struct AntennaTimelineView: View {
    
    let antenna: AntennaModel
    
    var body: some View {
        VStack {
            Timeline(timelineContext: AntennaTimelineContext(self.antenna.id!))
        }
        .fluentBackground()
        .safeAreaInset(edge: .top, spacing: 0) {
            BetterAppHeader(isNavLink: true) {
                AppHeaderSimpleBody {
                    HStack {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary.opacity(0.7))
                        Text(self.antenna.name!)
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
    AntennaTimelineView(antenna: .preview)
        .environmentObject(ViewContext())
}
