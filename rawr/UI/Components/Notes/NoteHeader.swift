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
    @ObservedObject var note: NoteModel
    
    var body: some View {
        HStack {
            HStack{
                NavigationLink(value: TappedMention(username: "@\(self.note.user!.username!)@\(self.note.user!.host ?? RawrKeychain().instanceHostname)")) {
                    RemoteImage(self.note.user?.avatarUrl)
                        .frame(width: 50, height: 50)
                        .cornerRadius(11)
                    VStack(alignment: .leading) {
                        Text(self.note.user.displayName())
                            .lineLimit(1)
                        Text("@" + (self.note.user.userName())).foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }.buttonStyle(PlainButtonStyle())
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
