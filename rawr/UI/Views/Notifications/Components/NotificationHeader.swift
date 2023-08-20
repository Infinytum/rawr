//
//  NotificationHeader.swift
//  rawr.
//
//  Created by Nila on 20.08.2023.
//

import SwiftUI

struct NotificationHeader: View {
    
    @EnvironmentObject var context: ViewContext
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                ProfileSwitcher()
                    .frame(width: 40, height: 40)
                Spacer()
            }
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("Notifications").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    NotificationHeader().environmentObject(ViewContext())
}
