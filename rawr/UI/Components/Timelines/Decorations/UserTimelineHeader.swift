//
//  UserTimelineHeader.swift
//  rawr.
//
//  Created by Dråfølin on 8/21/23.
//

import SwiftUI
import MisskeyKit

struct UserTimelineHeader: View {
    @State var user: UserModel?
    @Binding var selectedScope: UserTimelineContext.timelineScope
    
    var renderedNameNodes: MFMRenderViewStack {
        guard let user = self.user else {
            return []
        }
        
        let result = mfmRender(tokenize(user.name ?? ""), emojis: user.emojis ?? [])
        return result.renderedNote
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .center) {
                    HStack{
                        RemoteImage(user!.avatarUrl)
                            .frame(width: 50, height: 50)
                            .clipped()
                        ForEach(renderedNameNodes) {view in
                            view
                        }
                    }
                    .padding()
                    .background {
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7), .black.opacity(0.7), .clear]), startPoint: .top, endPoint: .bottom)
                            .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .clear]), startPoint: .leading, endPoint: .trailing))
                    }
                    Spacer()
                }
                .background {
                    RemoteImage(user!.bannerUrl)
                        .aspectRatio(1, contentMode: .fill)
                }
                .frame(maxHeight: 100)
                .clipped()
                HStack {
                    Spacer()
                    VStack {
                        Text(String(user!.notesCount!))
                            .bold()
                        Text("Notes")
                    }
                    Spacer()
                    VStack {
                        Text(String(user!.followersCount!))
                            .bold()
                        Text("Followers")
                    }
                    Spacer()
                    VStack {
                        Text(String(user!.followingCount!))
                            .bold()
                        Text("Following")
                    }
                    Spacer()
                }
            }
            Picker("Scope", selection: _selectedScope) {
                ForEach(UserTimelineContext.timelineScope.allCases) {scope in
                    Text(scope.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

#Preview {
    UserTimelineHeader(selectedScope: .constant(.notes))
}
