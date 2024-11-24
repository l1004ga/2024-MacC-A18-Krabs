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
    
    private init() {
        self._isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        let instrument = UserDefaults.standard.string(forKey: "selectedInstrument") ?? "장구"
        self._selectedInstrument = Instrument(rawValue: instrument) ?? .장구
    }
    
    // 최초실행여부
    private var _isFirstLaunch: Bool
    
    // 선택된 악기
    private var _selectedInstrument: Instrument
    
}

extension AppState {
    var isFirstLaunch: Bool { self._isFirstLaunch }
    
    var selectedInstrument: Instrument { self._selectedInstrument }
    
    func appLaunched() {
        self._isFirstLaunch = true
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
    
    func setInstrument(_ instrument: Instrument) {
        self._selectedInstrument = instrument
        UserDefaults.standard.set(instrument.rawValue, forKey: "selectedInstrument")
    }
}
