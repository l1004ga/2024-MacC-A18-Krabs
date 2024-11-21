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
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func pop(_ count: Int) {
        path.removeLast(count)
    }
}
