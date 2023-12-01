//
//  AppHeaderSimple.swift
//  rawr.
//
//  Created by Nila on 01.12.2023.
//

import SwiftUI

struct AppHeaderSimpleBody<Content: View>: View {
    @EnvironmentObject private var context: ViewContext
    
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(context.currentInstanceName)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            content
        }.padding(.leading, 5)
    }
}

#Preview {
    AppHeaderSimpleBody {
        HStack {
            Text("Incredible Subtitle")
        }
    }
        .environmentObject(ViewContext())
}
