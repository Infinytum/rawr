//
//  HastagTimelineHeader.swift
//  rawr.
//
//  Created by Dråfølin on 8/21/23.
//

import SwiftUI

struct HashtagTimelineHeader: View {
    @EnvironmentObject var context: ViewContext
    @State var presentedHashtag: String
    
    var body: some View {
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("#\(self.presentedHashtag)").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
            .font(.system(size: 20, weight: .thin)).padding(.top, 10)
    }
}

#Preview {
    HashtagTimelineHeader(presentedHashtag: "dergs")
}
