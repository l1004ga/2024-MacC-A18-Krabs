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
        self._didLaunchedBefore = UserDefaults.standard.bool(forKey: "didLaunchedBefore")
        
        let instrument = UserDefaults.standard.string(forKey: "selectedInstrument") ?? "장구"
        self._selectedInstrument = Instrument(rawValue: instrument) ?? .장구
    }
    
    // 최초실행여부
    private var _didLaunchedBefore: Bool
    
    // 선택된 악기
    private var _selectedInstrument: Instrument
    
}

extension AppState {
    var didLaunchedBefore: Bool { self._didLaunchedBefore }
    
    var selectedInstrument: Instrument { self._selectedInstrument }
    
    func appLaunched() {
        self._didLaunchedBefore = true
        UserDefaults.standard.set(true, forKey: "didLaunchedBefore")
    }
    
    func setInstrument(_ instrument: Instrument) {
        self._selectedInstrument = instrument
        UserDefaults.standard.set(instrument.rawValue, forKey: "selectedInstrument")
    }
}
