//
//  NoteHeader.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI
import NetworkImage
import MisskeyKit
import SwiftKit

struct NoteHeader: View {
    
    @EnvironmentObject var context: ViewContext
    @ObservedObject var viewReloader: ViewReloader = ViewReloader()
    @ObservedObject var note: NoteModel
    @State private var displayUserSheet = false
    
    var body: some View {
        HStack {
            HStack{
                NetworkImage(url: URL(string: self.note.user?.avatarUrl ?? "")) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.5))
                }.frame(width: 50, height: 50).cornerRadius(11)
                VStack(alignment: .leading) {
                    Text(self.note.user?.name ?? "<no name>")
                        .lineLimit(1)
                    Text("@" + (self.note.user?.username ?? "<nousername>")).foregroundStyle(.gray)
                        .lineLimit(1)
                }
            }
            .onTapGesture {
                displayUserSheet = true
                self.viewReloader.reloadView()
            }
            .sheet(isPresented: $displayUserSheet) {
                UserView(userName: "\(self.note.user!.username!)@\(self.note.user!.host!)")
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    RemoteImage(self.instanceUrl())
                        .frame(width: 20, height: 20)
                        .cornerRadius(6)
                    Text(self.instanceName())
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary.opacity(0.7))
                        .padding(.leading, -3)
                }
                Text(self.note.relativeCreatedAtTime())
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .padding(.top, -5)
            }
        }
    }
    
    private func instanceName() -> String {
        self.note.user?.instance?.name ?? self.context.currentInstance?.name ?? "<no name>"
    }
    
    private func instanceUrl() -> String? {
        self.note.user?.instance?.iconUrl ?? self.context.currentInstance?.getIconUrl()
    }
}

#Preview {
    NoteHeader(note: .preview.renote!)
        .environmentObject(ViewContext())
}
