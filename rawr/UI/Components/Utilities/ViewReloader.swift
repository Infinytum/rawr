//
//  ViewReloader.swift
//  rawr
//
//  Created by Nila on 12.08.2023.
//

import Foundation

class ViewReloader: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}
