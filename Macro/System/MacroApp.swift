//
//  MacroApp.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

@main
struct MacroApp: App {
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView()
            }
        }
        .environment(router)
    }
}
