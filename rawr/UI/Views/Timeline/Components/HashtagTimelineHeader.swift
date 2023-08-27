//
//  HastagTimelineHeader.swift
//  rawr.
//
//  Created by Dråfølin on 8/21/23.
//

import SwiftUI

struct HashtagTimelineHeader: View {

    @EnvironmentObject var context: ViewContext
    @State var hashtag: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                HStack {
                    Image(systemName: "number")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary.opacity(0.7))
                    Text(self.hashtag)
                        .foregroundColor(.primary.opacity(0.7))
                        .font(.system(size: 16))
                        .padding(.leading, -7)
                }.padding(.leading, -13)
            }
            Spacer()
        }
        .font(.system(size: 20))
        .padding(.horizontal).padding(.vertical, 10)
    }
}

#Preview {
    HashtagTimelineHeader(hashtag: "dragons")
        .environmentObject(ViewContext())
}
