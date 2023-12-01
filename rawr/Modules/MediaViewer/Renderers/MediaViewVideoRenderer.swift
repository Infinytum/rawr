//
//  MediaViewVideoRenderer.swift
//  rawr.
//
//  Created by Nila on 12.11.2023.
//

import AVKit
import SwiftUI

struct MediaViewVideoRenderer: View {
    
    @State var player: AVPlayer
    
    var body: some View {
        VideoPlayer(player: self.player)
            .clipped()
            .onAppear(perform: self.configureAVAudioSession)
            .onDisappear(perform: self.deconfigureAVAudioSession)
    }
    
    // This will ensure audio is played even when the device has its ringer volume muted
    func configureAVAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    // This will ensure audio is played even when the device has its ringer volume muted
    func deconfigureAVAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

#Preview {
    MediaViewVideoRenderer(player: AVPlayer(url: URL(string: "https://is-a.wyvern.rip/files/56a4d0c1-adfb-4faa-9616-b9cd3dc5bc6a")!))
}
