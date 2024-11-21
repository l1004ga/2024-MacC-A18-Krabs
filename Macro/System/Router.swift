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

    var path: [Int] = .init()
    
    func push(_ num: Int) {
        path.append(num)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func pop(_: Int) {
        path.removeLast(path.count)
    }
}
