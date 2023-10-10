//
//  BetterTimeline.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI
import SwiftKit
import UIKit

struct BetterTimeline: View {
    @ObservedObject var timeline: TimelineContextBase
    @ObservedObject var viewReloader = ViewReloader()
    
    @State var noteId: String = ""
    @State var noteDetailShown: Bool = false
    
    let scrollViewPadding: Int
    
    init(timelineContext: TimelineContextBase) {
        self.init(timelineContext: timelineContext, scrollViewPadding: 100)
    }
    
    init(timelineContext: TimelineContextBase, scrollViewPadding: Int) {
        self.scrollViewPadding = scrollViewPadding
        self.timeline = timelineContext
        timelineContext.initialize()
    }
    
    
    var body: some View {
        Group {
            if self.timeline.fetchError == nil {
                SingleAxisGeometryReader { width in
                    ScrollView {
                        LazyVStack(spacing: 0) {
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
                                .frame(width: width)
                                .overlay(alignment: .bottom) {
                                    Rectangle()
                                        .foregroundStyle(.gray.opacity(0.3))
                                        .frame(height: 0.5)
                                }
                            }
                        }
                    }
                    .safeAreaInset(edge: .top, content: {
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .frame(height: CGFloat(self.scrollViewPadding))
                    })
                    .safeAreaInset(edge: .bottom, spacing: 0, content: {
                        if self.timeline.fetchingItems {
                            if self.timeline.items.count <= 0 {
                                ProgressView().fluentBackground()
                            } else {
                                ProgressView()
                                    .fluentBackground()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .clipped()
                                    .cornerRadius(.infinity)
                                    .shadow(radius: 10)
                            }
                        }
                    })
                    .refreshable {
                        self.timeline.initialize()
                    }
                    .sheet(isPresented: self.$noteDetailShown) {
                        NoteView(noteId: self.noteId)
                    }
                }
            } else {
                VStack {
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .frame(height: CGFloat(self.scrollViewPadding))
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
