//
//  NoteBodyText.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI

struct NoteBodyText: View {
    let text: String
    
    @ObservedObject var viewReloader = ViewReloader()
    @State var renderedText: AnyView?
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.renderedText == nil {
                Text(self.text)
            } else {
                self.renderedText
            }
        }.padding(.top, 2).onAppear {
            render()
        }
    }
    
    private func render() {
        Task {
            let rendered = renderMFM(tokenize(self.text))
            self.renderedText = AnyView(rendered)
            DispatchQueue.main.async {
                withAnimation {
                    self.viewReloader.reloadView()
                }
            }
        }
    }
}

#Preview {
    NoteBodyText(text: "Short Text")
        .previewDisplayName("Short")
    
}
