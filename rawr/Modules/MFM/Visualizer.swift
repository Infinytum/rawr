//
//  Visualizer.swift
//  rawr.
//
//  Created by Nila on 14.08.2023.
//

import SwiftUI

struct Visualizer: View {
    let rootNode: MFMNodeProtocol
    
    var body: some View {
        VStack {
            Text(self.rootNode.type.rawValue)
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom)
            if self.rootNode.value != nil {
                Text(self.rootNode.value!)
            }
            ForEach(self.rootNode.children, id: \.value) { child in
                Visualizer(rootNode: child)
            }
        }.padding().border(.black)
    }
}

#Preview {
    Visualizer(rootNode: MFMNode(MFMNode(), plaintext: "Hello World"))
}
