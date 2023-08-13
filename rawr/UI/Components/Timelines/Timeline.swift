//
//  Timeline.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import MisskeyKit

struct Timeline: View {

    @ObservedObject var context: ViewContext
    @ObservedObject var timelineContext: TimelineContext
    
    init(context: ViewContext, timelineContext: TimelineContext) {
        self.context = context
        self.timelineContext = timelineContext
        timelineContext.requestInitialSetOfItems()
    }
    
    var body: some View {
        Group {
            if timelineContext.errorReason == nil {
                ScrollView {
                  LazyVStack {
                    ForEach(timelineContext.items, id: \.id) { item in
                        NoteView(context: self.context, note: item)
                            .listRowSeparator(.hidden)
                            .onAppear { timelineContext.requestMoreItemsIfNeeded(note: item) }
                        Divider().listRowSeparator(.hidden)
                    }

                    if timelineContext.dataIsLoading {
                      ProgressView()
                    }
                  }.padding()
                }
            } else {
                VStack {
                    Spacer()
                    Text(timelineContext.errorReason!)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Timeline(context: ViewContext(), timelineContext: TimelineContext(timelineType: .HOME))
}
