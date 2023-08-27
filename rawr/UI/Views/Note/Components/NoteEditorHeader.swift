//
//  NoteEditorViewHeader.swift
//  rawr.
//
//  Created by Nila on 27.08.2023.
//

import SwiftUI

struct NoteEditorHeader: View {
    
    @EnvironmentObject var context: ViewContext
    
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
                    Text("Send")
                }
            }
            VStack {
                Text(self.context.currentInstanceName).font(.system(size: 20, weight: .semibold)).foregroundColor(.primary)
                Text("New Note").foregroundColor(.primary.opacity(0.7))
                    .font(.system(size: 16))
                    .padding(.top, -12)
            }
        }.padding(.horizontal).padding(.vertical, 5).background(.thinMaterial)
    }
}

#Preview {
    NoteEditorHeader(previewEnabled: .constant(true))
        .environmentObject(ViewContext())
}
