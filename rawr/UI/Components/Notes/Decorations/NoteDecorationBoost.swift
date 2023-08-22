//
//  NoteDecorationBoost.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import MisskeyKit

struct NoteDecorationBoost: View {
    @ObservedObject var note: NoteModel
    @ObservedObject var viewRefresher = ViewReloader()
    
    @State var presentUserSheet = false
    @State var presentedUser = ""

    var body: some View {
        HStack {
            Image(systemName: "arrow.2.squarepath")
                .padding(.leading, 12)
            Group {
                Text("Boosted by ")
                    .foregroundColor(.primary.opacity(0.7)) +
                Text(self.note.user?.name ?? "<no name>")
                    .foregroundColor(.blue)
            }.font(.system(size: 15))
                .padding(.leading, 12)
            Spacer()
            Text(self.note.relativeCreatedAtTime())
                .foregroundColor(.primary.opacity(0.7))
                .font(.system(size: 15))
        }.sheet(isPresented: $presentUserSheet) {
            UserView(userName: presentedUser)
        }.onTapGesture {
            self.presentedUser = "\(self.note.user?.username ?? "")@\(self.note.user?.host ?? "")"
            self.viewRefresher.reloadView()
            self.presentUserSheet = true
        }
    }
}

#Preview {
    NoteDecorationBoost(note: .preview)
}
