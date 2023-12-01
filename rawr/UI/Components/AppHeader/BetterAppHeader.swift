//
//  BetterAppHeader.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import SwiftUI

struct BetterAppHeader<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isNavLink: Bool = false
    
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            if self.isNavLink {
                Button {
                    self.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .frame(width: 50, height: 50)
                        .font(.system(size: 25))
                        .foregroundColor(.primary)
                        .clipped()
                        .cornerRadius(.infinity)
                }
            } else {
                ProfileSwitcher()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(11)
            }
            content
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .fluentBackground(.regular, fullscreen: false)
    }
}

#Preview {
    BetterAppHeader {
        Spacer()
    }
}
