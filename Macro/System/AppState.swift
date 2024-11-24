//
//  AppState.swift
//  Macro
//
//  Created by Yunki on 11/24/24.
//

import SwiftUI

@Observable
class AppState {
    static let shared = AppState()
    
    private init() {}
    
    // 최초실행여부
    var isSelectedInstrument: Bool {
        get { UserDefaults.standard.bool(forKey: "isSelectedInstrument") }
        set { UserDefaults.standard.set(newValue, forKey: "isSelectedInstrument") }
    }
    
    // 선택된 악기
    var selectInstrument: Instrument {
        get {
            guard let instrument = UserDefaults.standard.string(forKey: "selectInstrument") else { return .장구 }
            return Instrument(rawValue: instrument) ?? .장구
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "isSelectedInstrument") }
    }
}
