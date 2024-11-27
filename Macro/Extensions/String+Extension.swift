//
//  String+Extension.swift
//  Macro
//
//  Created by Lee Wonsun on 11/28/24.
//

import SwiftUI

extension String {
    func truncated(_ limit: Int) -> String {
        return self.count > limit ? String(self.prefix(limit)) + "..." : self
    }
}
