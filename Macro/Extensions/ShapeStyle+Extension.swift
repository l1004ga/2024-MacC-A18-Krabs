//
//  ShapeStyle+Extension.swift
//  Macro
//
//  Created by Yunki on 11/18/24.
//

import SwiftUICore

extension ShapeStyle {
    static var bakBarGradient: LinearGradient {
        .init(colors: [.bakBarActiveTop, .bakBarActiveBottom], startPoint: .top, endPoint: .bottom)
    }
}
