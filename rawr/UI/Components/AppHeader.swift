//
//  AppHeader.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

struct AppHeader<Content: View>: View {
    
    @EnvironmentObject private var context: ViewContext
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
                Image(.dergSocialIcon)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(.infinity)
            }
            VStack(alignment: .leading) {
                Text(context.currentInstanceName)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                content
            }.padding(.leading, 5)
            Spacer()
//            Image(systemName: "bell")
//                .font(.system(size: 23))
//                .frame(width: 50, height: 50)
//                .overlay(alignment: .topTrailing) {
//                    Rectangle()
//                        .frame(width: 15, height: 15)
//                        .foregroundColor(.red)
//                        .cornerRadius(.infinity)
//                        .offset(CGSize(width: -2.0, height: 2.0))
//                }
//                .padding(.trailing, 5)
            ProfileSwitcher()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(.infinity)
        }
        .padding(.horizontal, 15)
        .padding(.top)
        .padding(.bottom, 10)
        .fluentBackground(.regular, fullscreen: false)
    }
}

#Preview {
    VStack {
        Spacer()
        VStack {
            AppHeader {
                HStack {
                    Text("Incredible Subtitle")
                }
            }
            .environmentObject(ViewContext())
            AppHeader(isNavLink: true) {
                HStack {
                    Text("Incredible Subtitle")
                }
            }
            .environmentObject(ViewContext())
        }
        .background(.background)
        Spacer()
    }.background(.primary)
}
