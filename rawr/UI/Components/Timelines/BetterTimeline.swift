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
    
    init(timelineContext: TimelineContextBase) {
        self.timeline = timelineContext
        timelineContext.initialize()
    }
    
    var body: some View {
        Group {
            if self.timeline.fetchError == nil {
                if self.timeline.firstLoadCompleted {
                    SingleAxisGeometryReader { width in
                        ScrollView {
                            if self.timeline.fetchingItems && self.timeline.items.count <= 0 {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: 100)
                            } else {
                                LazyVStack(spacing: 0) {
                                    ForEach(self.timeline.items, id: \.note.id) { item in
                                        NavigationLink(destination: NoteView(noteId: item.note.id!).navigationBarBackButtonHidden(true)) {
                                            Note(note: item.note, renderedNote: item.renderedNote)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                            .onAppear { self.timeline.fetchItemsIfNeeded(item) }
                                            .padding(.vertical)
                                            .fluentBackground()
                                            .frame(width: width)
                                            .overlay(alignment: .bottom) {
                                                Rectangle()
                                                    .foregroundStyle(.gray.opacity(0.3))
                                                    .frame(height: 0.5)
                                            }
                                            .contentShape(Rectangle())
                                    }
                                }
                            }
                        }.onTapGesture {}
                        .safeAreaInset(edge: .bottom, spacing: 0, content: {
                            if self.timeline.fetchingItems && self.timeline.items.count > 0 {
                                ProgressView()
                                    .fluentBackground()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .clipped()
                                    .cornerRadius(.infinity)
                                    .shadow(radius: 10)
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
                    Spacer()
                    ProgressView()
                    Spacer()
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
    BetterTimeline(timelineContext: HomeTimelineContext())
        .environmentObject(ViewContext())
}
