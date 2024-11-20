//
//  MacroApp.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

@main
struct MacroApp: App {
    
    @AppStorage("selectInstrument") var selectInstrument: Instrument = .장구
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
