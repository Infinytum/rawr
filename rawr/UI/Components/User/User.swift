//
//  User.swift
//  rawr.
//
//  Created by Nila on 21.08.2023.
//

import MisskeyKit
import SwiftUI

struct User: View {
    
    let user: UserModel
    
    @State private var selectedScope: UserTimelineContext.timelineScope = .notes
    @State private var headerCollapsed: Bool = false
    
    var body: some View {
        VStack {
            if self.headerCollapsed {
                UserHeader(user: self.user, collapsed: self.$headerCollapsed)
                    .highPriorityGesture(DragGesture(minimumDistance: 10).onChanged({ transition in
                        if transition.translation.height > 0 {
                            withAnimation{
                                self.headerCollapsed = false
                            }
                        }
                    }))
                    .transition(.move(edge: .top))
            } else {
                UserHeader(user: self.user, collapsed: self.$headerCollapsed)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .layoutPriority(2)
            }
            Picker("Scope", selection: self.$selectedScope) {
                ForEach(UserTimelineContext.timelineScope.allCases) {scope in
                    Text(scope.rawValue.capitalized)
                }
            }.pickerStyle(.segmented).padding(.top, 10).padding(.horizontal, 20)
                .gesture(DragGesture(minimumDistance: 10)
                    .onChanged({ transition in
                        if transition.translation.height < 0 {
                            withAnimation{
                                self.headerCollapsed = true
                            }
                        }
                    })
                    .onEnded({ transition in
                        if transition.translation.height > 0 {
                            withAnimation{
                                self.headerCollapsed = false
                            }
                        }
                    })
                )
            Timeline(timelineContext: UserTimelineContext(self.user.id, self.selectedScope))
                .highPriorityGesture(DragGesture(minimumDistance: 10).onChanged({ transition in
                    if transition.translation.height < 0 {
                        withAnimation{
                            self.headerCollapsed = true
                        }
                    }
                }))
                .interactiveDismissDisabled(self.headerCollapsed)
                .frame(minHeight: 100)
                .layoutPriority(-1)
        }
    }
}

#Preview {
    VStack {
    }.sheet(isPresented: .constant(true)) {
        VStack {
            User(user: .preview)
            Spacer()
        }
    }.presentationDragIndicator(.visible)
        .environmentObject(ViewContext())
}
