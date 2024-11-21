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
                    .navigationDestination(for: Route.self) { path in
                        switch path {
                        case .homeScreen:
                            HomeView()
                        case .metoronomeScreen:
                            MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: <#String#>)
                        case .customJangdanListScreen:
                            CustomJangdanListView()
                        case .customJangdanTypeSelectScreen:
                            JangdanTypeSelectView()
                        case .customJangdanCreateScreen:
                            CustomJangdanCreateView()
                        case .customJangdanPracticeScreen:
                            MetronomeView()
                        }
                    }
            }
        }
        .environment(router)
    }
}
