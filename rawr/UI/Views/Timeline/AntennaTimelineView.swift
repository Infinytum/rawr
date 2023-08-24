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
        AntennaTimelineHeader(presentedAntennaName: self.antenna.name!)
        Spacer()
        Timeline(timelineContext: AntennaTimelineContext(self.antenna.id!))
        Spacer()
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true)) {
        AntennaTimelineView(antenna: .preview)
    }.environmentObject(ViewContext())
}
