//
//  Timeline.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import MisskeyKit

struct Timeline: View {

    @ObservedObject var timelineContext: TimelineContext
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var noteId: String? = nil
    @State var noteDetailShown: Bool = false
    
    init(timelineContext: TimelineContext) {
        self.timelineContext = timelineContext
        timelineContext.requestInitialSetOfItems()
    }
    
    var body: some View {
        Group {
            if timelineContext.errorReason == nil {
                ScrollView {
                  LazyVStack {
                    ForEach(timelineContext.items, id: \.id) { item in
                        Note(note: item)
                            .listRowSeparator(.hidden)
                            .onAppear { timelineContext.requestMoreItemsIfNeeded(note: item) }
                            .onTapGesture {
                                self.noteId = item.id
                                self.viewReloader.reloadView()
                                self.noteDetailShown = true
                            }
                        Divider().listRowSeparator(.hidden)
                    }

                    if timelineContext.dataIsLoading {
                      ProgressView()
                    }
                  }.padding()
                }.sheet(isPresented: self.$noteDetailShown) {
                    NoteView(noteId: self.noteId!)
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
    Timeline(timelineContext: TimelineContext(timelineType: .HOME))
}
