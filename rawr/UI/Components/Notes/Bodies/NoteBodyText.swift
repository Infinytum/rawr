//
//  NoteBodyText.swift
//  Derg Social
//
//  Created by Nila on 05.08.2023.
//

import SwiftUI

struct NoteBodyText: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.text)
        }.padding(.top, 2)
    }
}

#Preview {
    NoteBodyText(text: "Short Text")
        .previewDisplayName("Short")
    
}
