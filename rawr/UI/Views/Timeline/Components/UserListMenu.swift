//
//  UserListMenu.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import MisskeyKit
import SwiftUI

struct UserListMenu: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State var lists: [ListModel]?
    
    var body: some View {
        Menu {
            if self.lists == nil {
                Text("Loading Lists...")
            } else if self.lists!.isEmpty {
                Text("No Lists")
            } else {
                ForEach(self.lists!) { list in
                    NavigationLink(destination: ListTimelineView(list: list).navigationBarBackButtonHidden(true)) {
                        Text(list.name ?? "Unnamed List")
                    }
                }
            }
        } label: {
            Image(systemName: "list.bullet")
                .font(.system(size: 20))
        }.onAppear(perform: self.onAppear)
    }
    
    private func onAppear() {
        MisskeyKit.shared.lists.getMyLists { lists, error in
            guard let lists = lists else {
                context.applicationError = ApplicationError(title: "Fetching Lists failed", message: error.explain())
                print("UserListMenu: Failed to fetch list of lists: \(error!)")
                self.lists = []
                return
            }
            self.lists = lists
        }
    }
}

#Preview {
    UserListMenu()
}
