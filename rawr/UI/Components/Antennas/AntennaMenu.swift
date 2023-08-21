//
//  AntennaMenu.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import MisskeyKit
import SwiftUI

struct AntennaMenu: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var antennas: [AntennaModel]?
    @State var presentAntennaSheet = false
    @State var presentedAntenna: AntennaModel?
    
    var body: some View {
        Menu {
            if self.antennas == nil {
                Text("Loading Antennas...")
            } else if self.antennas!.isEmpty {
                Text("No Antennas")
            } else {
                ForEach(self.antennas!) { antenna in
                    Button(antenna.name ?? "Unnamed Antenna") {
                        self.presentedAntenna = antenna
                        self.viewReloader.reloadView()
                        self.presentAntennaSheet = true
                    }
                }
            }
        } label: {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 20))
        }.onAppear(perform: self.onAppear)
        .sheet(isPresented: $presentAntennaSheet, content: {
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("\(self.presentedAntenna!.name ?? "Unnamed Antenna")").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
            .font(.system(size: 20, weight: .thin)).padding(.top, 10)
            Timeline(timelineContext: AntennaTimelineContext(self.presentedAntenna!.id!))
        })
    }
    
    private func onAppear() {
        MisskeyKit.shared.antennas.list { antennas, error in
            guard let antennas = antennas else {
                context.applicationError = ApplicationError(title: "Fetching Antennas failed", message: error.explain())
                print("AntennaMenu: Failed to fetch list of antennas: \(error!)")
                self.antennas = []
                return
            }
            
            self.antennas = antennas
        }
    }
}

#Preview {
    AntennaMenu().environmentObject(ViewContext())
}
