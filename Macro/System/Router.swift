//
//  Router.swift
//  Macro
//
//  Created by Lee Wonsun on 11/21/24.
//

import SwiftUI

enum Route: Hashable {
    case homeScreen
    case metoronomeScreen
    case customJangdanListScreen
    case customJangdanTypeSelectScreen
    case customJangdanCreateScreen
    case customJangdanPracticeScreen
}

@Observable
class Router {
    
    var path: [Route] = .init()
    
//    func view(for route: Route) -> some View {
//        switch route {
//        case .homeScreen:
//            return AnyView(HomeView())
//        case let .metoronomeScreen(viewModel, jangdanName):
//            return AnyView(MetronomeView(viewModel: viewModel, jangdanName: jangdanName))
//        case let .customJangdanListScreen(jangdanList):
//            return AnyView(CustomJangdanListView(jangdanList: jangdanList))
//        case .customJangdanTypeSelectScreen:
//            return AnyView(JangdanTypeSelectView())
//        case let .customJangdanCreateScreen(viewModel, jangdanName):
//            return AnyView(CustomJangdanCreateView(viewModel: viewModel, jangdanName: jangdanName))
//        case let .customJangdanPracticeScreen(viewModel, jangdanName):
//            return AnyView(MetronomeView(viewModel: viewModel, jangdanName: jangdanName))
//        }
//    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func pop(_: Int) {
        path.removeLast(path.count)
    }
}
