//
//  MainViewFooter.swift
//  rawr.
//
//  Created by Nila on 18.09.2023.
//

import SwiftUI

enum MainViewTab {
    case home
    case chats
    case explore
    case notifications
}

struct MainViewFooter: View {
    
    @Binding var selectedTab: MainViewTab
    @State var showNewNote: Bool = false
    
    var body: some View {
        HStack {
            self.highlightable(tab: MainViewTab.home) {
                VStack {
                    Image(systemName: "house")
                        .font(.system(size: 24))
                }
            }
            Spacer()
            self.highlightable(tab: MainViewTab.chats) {
                VStack {
                    Image(systemName: "message")
                        .font(.system(size: 24))
                }
            }
            Spacer()
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .background(
                        Rectangle()
                            .frame(width: 65, height: 45)
                            .foregroundColor(.clear)
                            .fluentBackground(.ultraThin)
                            .cornerRadius(.infinity)
                    )
                    .foregroundColor(.primary)
            }
            .shadow(color: .black.opacity(0.15), radius: 10)
            .sheet(isPresented: self.$showNewNote, content: {
                NoteEditorView()
            })
            .onTapGesture {
                self.showNewNote.toggle()
            }
            Spacer()
            self.highlightable(tab: MainViewTab.notifications) {
                VStack {
                    Image(systemName: "bell")
                        .font(.system(size: 24))
                }
            }
            Spacer()
            self.highlightable(tab: MainViewTab.explore) {
                VStack {
                    Image(systemName: "number")
                        .font(.system(size: 24))
                }
            }.disabled(true).opacity(0.5)
        }
        .padding(.top, 15)
        .padding(.bottom, 10)
        .padding(.horizontal, 35)
    }
    
    @ViewBuilder
    private func highlightable(tab: MainViewTab, content: () -> some View) -> some View {
        Button(action: {
            self.selectedTab = tab
        }, label: {
            if tab == self.selectedTab {
                content()
                    .foregroundColor(.primary)
                    .overlay(alignment: .bottom, content: {
                        Rectangle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 5)
                            .cornerRadius(.infinity)
                            .clipped()
                            .offset(CGSize(width: 0.0, height: 15.0))
                    })
            } else {
                content()
                    .foregroundColor(.primary.opacity(0.5))
            }
        })
    }
}

#Preview {
    VStack {
        Spacer()
        Text("The Amazing Content")
        Spacer()
        MainViewFooter(selectedTab: .constant(.home)).fluentBackground(.regular, fullscreen: false)
    }.environmentObject(ViewContext())
}
