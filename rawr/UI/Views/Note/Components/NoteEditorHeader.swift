//
//  NoteEditorViewHeader.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NoteEditorHeader: View {
    
    @EnvironmentObject var context: ViewContext
    
    @State private var selectedTimeline = 0
    @Binding var previewEnabled: Bool
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                ProfileSwitcher()
                    .frame(width: 40, height: 40)
                Spacer()
                Button {
                    self.previewEnabled.toggle()
                } label: {
                    Image(systemName: "binoculars")
                        .frame(width: 40, height: 30)
                        .background(self.previewEnabled ? .blue : .clear)
                        .foregroundColor(self.previewEnabled ? .white : .primary)
                        .cornerRadius(.infinity)
                }.padding(.trailing, 5)
                Button {
                    self.previewEnabled.toggle()
                } label: {
                    Text("Post")
                }
            }
            TimelineSelector(selectedTab: self.$selectedTimeline)
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    NoteEditorHeader(previewEnabled: .constant(true))
        .environmentObject(ViewContext())
}
