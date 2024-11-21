//
//  Date+Extension.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
}
