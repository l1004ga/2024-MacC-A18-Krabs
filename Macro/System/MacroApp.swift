//
//  MacroApp.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

@main
struct MacroApp: App {
    let diContiner: DIContainer = .shared
    var body: some Scene {
        WindowGroup {
            JangdanSelectView()
        }
    }
}
