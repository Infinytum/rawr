//
//  Environment.swift
//  rawr.
//
//  Created by Nila on 12.10.2023.
//

import Foundation
import SwiftUI

private struct EmojiRenderSize: EnvironmentKey {
    static let defaultValue: CGSize? = CGSize(width: 30, height: 30)
}

extension EnvironmentValues {
  var emojiRenderSize: CGSize? {
    get { self[EmojiRenderSize.self] }
    set { self[EmojiRenderSize.self] = newValue }
  }
}
