//
//  UserHeader.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import MisskeyKit
import SwiftUI
import SwiftKit

struct UserHeader: View {
    
    let user: UserModel
    @Binding var collapsed: Bool
    @State private var scrollViewContentSize: CGSize = .zero
    
    var body: some View {
        VStack {
            VStack { HStack { Spacer() } }
                .frame(height: self.collapsed ? 75 : 200)
            .background(
                RemoteImage(self.user.bannerUrl)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: self.collapsed ? 75 : 200, alignment: .center)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .clear,
                                    .clear,
                                    .black.opacity(0.4),
                                    .black.opacity(0.7),
                                    .black.opacity(0.7)
                                ]
                            ), startPoint: .top, endPoint: .bottom
                        )
                        .mask(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.black, .black, .black, .clear]
                                ), startPoint: .leading, endPoint: .trailing)
                        )
                    }
            )
            .overlay(alignment: .bottomLeading) {
                HStack(alignment: .top) {
                    RemoteImage(self.user.avatarUrl)
                        .frame(width: self.collapsed ? 60 : 100, height: self.collapsed ? 60 : 100)
                        .cornerRadius(11)
                        .shadow(radius: 5)
                    VStack(alignment: .leading) {
                        MFMBody(render: self.getRenderedUsername())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 7)
                            .frame(maxHeight: 60)
                            .frame(height: 60)
                        if !self.collapsed {
                            Text("@\(self.user.username!)@\(self.user.host ?? RawrKeychain().instanceHostname)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary.opacity(0.9))
                                .lineLimit(1, reservesSpace: true)
                                .padding(.top, 4)
                        }
                    }
                }.offset(x: 0, y: self.collapsed ? -7 : 35).padding(.horizontal, 20)
            }.padding(.bottom, self.collapsed ? -7 : 35)
            if !self.collapsed {
                ScrollView() {
                    MFMBody(render: self.getRenderedDescription())
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        .background(
                            GeometryReader { geo -> Color in
                                DispatchQueue.main.async {
                                    scrollViewContentSize = geo.size
                                }
                                return Color.clear
                            }
                        )
                }.frame(
                    maxHeight: scrollViewContentSize.height
                )
                Divider().padding(.horizontal, 20)
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
                }.padding(.top, 10).padding(.horizontal, 20)
            }
        }
    }
    
    private func getRenderedDescription() -> MFMRender {
        return mfmRender(tokenize(self.user.description ?? ""), emojis: self.user.emojis ?? [])
    }
    
    private func getRenderedUsername() -> MFMRender {
        return mfmRender(tokenizeEmojisOnly(self.user.name ?? ""), emojis: self.user.emojis ?? [], plaintextWordlets: 2)
    }
}

#Preview {
//    VStack {
//        
//    }.sheet(isPresented: .constant(true)) {
//        VStack {
//            UserHeader(user: .preview, collapsed: .constant(true))
//            Spacer()
//            UserHeader(user: .preview, collapsed: .constant(false))
//            Spacer()
//        }
//    }.presentationDragIndicator(.visible).environmentObject(ViewContext())
    VStack {
    }.sheet(isPresented: .constant(true)) {
        VStack {
            User(user: .preview)
            Spacer()
        }
    }.presentationDragIndicator(.visible)
        .environmentObject(ViewContext())
}
