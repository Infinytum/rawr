//
//  UserView.swift
//  rawr.
//
//  Created by Dråfølin on 8/20/23.
//

import SwiftUI
import MisskeyKit

struct UserView: View {
    @EnvironmentObject var context: ViewContext
    
    @State var userName: String
    @State private var user: UserModel?
    @State private var error: MisskeyKitError?
    @State private var isErrored: Bool = false
    @State private var selectedScope: UserTimelineContext.timelineScope = .notes
    
    var renderedNameNodes: MFMRenderViewStack {
        guard let user = self.user else {
            return []
        }
        
        let result = mfmRender(tokenize(self.user!.name ?? ""), emojis: self.user!.emojis ?? [])
        return result.renderedNote
    }

    
    var body: some View {
        VStack {
            if user != nil {
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
                Picker("Scope", selection: $selectedScope) {
                    ForEach(UserTimelineContext.timelineScope.allCases) {scope in
                        Text(scope.rawValue.capitalized)
                    }
                }
                    .pickerStyle(.segmented)
                    .padding()
                Timeline(timelineContext: UserTimelineContext(user!.id, selectedScope))
            } else if !isErrored {
                Text("Loading...")
            } else {
                Image(systemName: "triangle.exclamationmark")
            }
        }
        .alert(error?.localizedDescription ?? "no error", isPresented: $isErrored) {
        }
        .onAppear{
            // MARK: User initialisation
            var userComponents = userName.components(separatedBy: "@")
            userComponents.removeFirst()
            if userComponents.count == 1 {
                let username = userComponents[0]
                MisskeyKit.shared.users.showUser(username: username) {user,err in
                    guard err == nil else {
                        return
                    }
                    self.user = user
                }
            } else if userComponents.count == 2 {
                MisskeyKit.shared.users.showUser(username:  userComponents[0], host: userComponents[1]) {user,err in
                    guard err == nil else {
                        return
                    }
                    
                    self.user = user
                }
                
            } else {
                return
            }
        }
        
    }
}

#Preview {
    UserView(userName: "dråfølin")
}
