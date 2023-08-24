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
        HStack(alignment: .center) {
                Image(systemName: "number")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary.opacity(0.7))

                Text(self.presentedHashtag)
            }
            .font(.system(size: 20))
            .padding(.top, 10)
    }
}

#Preview {
    HashtagTimelineHeader(presentedHashtag: "dergs")
}
