//
//  Router.swift
//  Macro
//
//  Created by Lee Wonsun on 11/21/24.
//

import SwiftUI

enum Route: Hashable {
    case customJangdanList
    case jangdanTypeSelect
    case customJangdanCreate(jangdanName: String)
}

@Observable
class Router {
    var path: [Route] = .init()
    
    func view(for route: Route) -> some View {
        switch route {
        case .customJangdanList:
            return AnyView(CustomJangdanListView(viewModel: DIContainer.shared.customJangdanListViewModel))
        case .jangdanTypeSelect:
            return AnyView(JangdanTypeSelectView())
        case let .customJangdanCreate(jangdanName):
            return AnyView(CustomJangdanCreateView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdanName))
        }
    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop(_ count: Int = 1) {
        path.removeLast(count)
    }
}
