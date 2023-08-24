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
            Spacer()
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary.opacity(0.7))
                    Text(self.presentedAntennaName)
                        .foregroundColor(.primary.opacity(0.7))
                        .font(.system(size: 16))
                        .padding(.leading, -5)
                }.padding(.leading, -15)
            }
            Spacer()
        }
        .font(.system(size: 20))
        .padding(.horizontal).padding(.vertical, 10).background(.thinMaterial)
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true)) {
        AntennaTimelineHeader(presentedAntennaName: "Antenna")
        Spacer()
    }.environmentObject(ViewContext())
}
