//
//  ProfileSwitcher.swift
//  Derg Social
//
//  Created by Nila on 06.08.2023.
//

import SwiftUI
import NetworkImage

struct ProfileSwitcher: View {
    var body: some View {
        Menu {
            Section("Available Accounts") {
                Button("First") {  }
                Button("Second") {  }
            }
            Button {
            } label: {
                Label("Add Account", systemImage: "person.badge.plus")
            }
            Button(role: .destructive) {
                RawrKeychain().apiKey = nil
            } label: {
                Label("Logout", systemImage: "trash")
            }
        } label: {
            NetworkImage(url: URL(string: "https://cdn.derg.social/calckey/thumbnail-0d7ce0df-da12-4c06-9d9d-c10c1ec3fcfd.webp")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.5))
            }.cornerRadius(11)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ProfileSwitcher()
            .frame(width: 75, height: 75)
            .padding(.bottom, 20)
        Text("Profile Switcher")
            .font(.system(size: 25, weight: .thin))
        Text("Switch profile by tapping the current profile")
            .font(.system(size: 18, weight: .thin))
        Spacer()
    }.padding()
}
