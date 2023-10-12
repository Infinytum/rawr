//
//  BetterUserHeader.swift
//  rawr.
//
//  Created by Nila on 12.10.2023.
//

import MisskeyKit
import SwiftKit
import SwiftUI

struct BetterUserHeader: View {
    
    var user: UserModel = .preview
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.clear)
                .background(RemoteImage(user.bannerUrl), alignment: .center)
                .aspectRatio(3, contentMode: .fit)
                .clipped()
                .overlay(alignment: .bottom) {
                    self.bannerOverlay
                        .frame(height: 100)
                        .offset(y: 40)
                }.padding(.bottom, 40)
            MFMBody(render: self.getRenderedDescription())
                .padding(.horizontal)
                .padding(.top, 5)
            Divider()
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
            HStack {
                Spacer()
                VStack {
                    Text(String(self.user.followersCount!))
                        .bold()
                    Text("Followers")
                }
                Spacer()
                VStack {
                    Text(String(self.user.notesCount!))
                        .bold()
                    Text("Notes")
                }
                Spacer()
                VStack {
                    Text(String(self.user.followingCount!))
                        .bold()
                    Text("Following")
                }
                Spacer()
            }
        }
    }
    
    var bannerOverlay: some View {
        HStack {
            RemoteImage(self.user.avatarUrl)
                .frame(width: 75, height: 75)
                .cornerRadius(11)
                .shadow(radius: 5)

            VStack(alignment: .leading) {
                Text(self.user.name ?? "")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1, reservesSpace: true)
                Text("@\(self.user.username!)@\(self.user.host ?? RawrKeychain().instanceHostname)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1, reservesSpace: true)
            }
            .padding(.leading, 1)
            .padding(.bottom, 30)
            
            Spacer()
        }
        .padding(.horizontal)
        .background(
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.6), .clear]), startPoint: .bottom, endPoint: .top).offset(y: -27)
        )
    }
    
    private func getRenderedDescription() -> MFMRender {
        return mfmRender(tokenize(self.user.description ?? ""), emojis: self.user.emojis ?? [])
    }
}

#Preview {
    VStack {
        NavigationStack {
            VStack(spacing: 0) {
                BetterUserHeader()
                Spacer()
            }.fluentBackground()
                .safeAreaInset(edge: .top, spacing: 0) {
                        AppHeader {
                            Text("Profile")
                        }
                }
        }
    }.background(.black).environmentObject(ViewContext())
}
