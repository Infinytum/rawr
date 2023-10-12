//
//  NoteEditorViewHeader.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NoteEditorHeader: View {
    
    @EnvironmentObject var context: ViewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTimeline = 0
    @Binding var previewEnabled: Bool
    @Binding var localOnly: Bool
    
    var onPost: () -> Void
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    self.localOnly.toggle()
                } label: {
                    Image(systemName: "network.slash")
                        .frame(width: 40, height: 30)
                        .background(self.localOnly ? .blue : .clear)
                        .foregroundColor(self.localOnly ? .white : .primary)
                        .cornerRadius(.infinity)
                }.padding(.trailing, 5)
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
                    self.onPost()
                } label: {
                    Text("Post")
                }
            }
            Text("New Rawr")
                .font(.system(size: 18, weight: .bold, design: .rounded))
        }.padding(.horizontal).padding(.vertical, 10).background(.thinMaterial)
    }
}

#Preview {
    NoteEditorHeader(previewEnabled: .constant(true), localOnly: .constant(true)) {
        
    }
        .environmentObject(ViewContext())
}
