//
//  AntennaTimelineHeader.swift
//  rawr.
//
//  Created by Dråfølin on 8/21/23.
//

import SwiftUI
import MisskeyKit

struct AntennaTimelineHeader: View {
    @EnvironmentObject var context: ViewContext
    
    @State var presentedAntennaName: String
    var body: some View {
        HStack {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary.opacity(0.7))
            Text(self.presentedAntennaName)
        }
        .font(.system(size: 20))
        .padding(.top, 10)
    }
}

#Preview {
    AntennaTimelineHeader(presentedAntennaName: "Antenna")
}
