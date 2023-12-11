//
//  RelativeDate.swift
//  rawr.
//
//  Created by Nila on 11.12.2023.
//

import SwiftUI

struct RelativeDate: View {
    let date: Date
    let to: Date?
    let later: Bool
    
    private let timer = Timer.publish(
       every: 1, // second
       on: .main,
       in: .common
    ).autoconnect()

    @State private var secondStr: String? = nil

    init(date: Date = Date(), to: Date? = nil, later: Bool = false) {
        self.date = date
        self.to = to
        self.later = later
    }

    var body: some View {
        Text(secondStr ?? self.format())
            .monospacedDigit()
           .onReceive(timer) { (_) in
               self.secondStr = self.format()
           }
    }
    
    private func format() -> String {
        if self.later {
            return self.date.formatted(.customRelativeLater(to: self.to ?? Date()))
        }
        return self.date.formatted(.customRelative(to: self.to ?? Date()))
    }
}

#Preview {
    VStack {
        RelativeDate()
        RelativeDate(later: true)
    }
}
