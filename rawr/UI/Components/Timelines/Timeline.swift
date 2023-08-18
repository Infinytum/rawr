//
//  Timeline.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import MisskeyKit

struct Timeline: View {

    @ObservedObject var timeline: TimelineContextBase
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var noteId: String = ""
    @State var noteDetailShown: Bool = false
    
    init(timelineContext: TimelineContextBase) {
        self.timeline = timelineContext
        timelineContext.initialize()
    }
    
    var body: some View {
        Group {
            if self.timeline.fetchError == nil {
                ScrollView {
                    LazyVStack() {
                        ForEach(self.timeline.items, id: \.note.id) { item in
                            Note(note: item.note, renderedNote: item.renderedNote)
                                .listRowSeparator(.hidden)
                                .onAppear { self.timeline.fetchItemsIfNeeded(item) }
                                .onTapGesture {
                                    self.noteId = item.note.id!
                                    self.viewReloader.reloadView()
                                    self.noteDetailShown = true
                                }
                            Divider().listRowSeparator(.hidden)
                        }

                        if self.timeline.fetchingItems {
                          ProgressView()
                        }
                    }.padding()
                }.sheet(isPresented: self.$noteDetailShown) {
                    NoteView(noteId: self.noteId)
                }
            } else {
                VStack {
                    Spacer()
                    Text("Couldn't fetch Timeline")
                        .font(.system(size: 20, weight: .regular))
                    Text(self.timeline.fetchError!)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Timeline(timelineContext: HomeTimelineContext())
}
