//
//  BetterTimeline.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

import UIKit

struct BetterTimeline: View {
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
                SingleAxisGeometryReader { width in
                    ScrollView {
                        LazyVStack() {
                            ForEach(self.timeline.items, id: \.note.id) { item in
                                Note(note: item.note, renderedNote: item.renderedNote)
                                .onAppear { self.timeline.fetchItemsIfNeeded(item) }
                                .onTapGesture {
                                    self.noteId = item.note.id!
                                    self.viewReloader.reloadView()
                                    self.noteDetailShown = true
                                }
                                .padding(.vertical)
                                .fluentBackground()
                                .cornerRadius(20)
                                .padding(.horizontal, 10)
                                .frame(width: width)
                            }

                            if self.timeline.fetchingItems {
                              ProgressView()
                            }
                        }
                    }
                    .refreshable {
                        self.timeline.initialize()
                    }
                    .sheet(isPresented: self.$noteDetailShown) {
                        NoteView(noteId: self.noteId)
                    }
                }
            } else {
                VStack {
                    Text("Couldn't fetch Timeline")
                        .font(.system(size: 20, weight: .regular))
                    Text(self.timeline.fetchError!)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    BetterTimeline(timelineContext: HomeTimelineContext())
        .environmentObject(ViewContext())
}
