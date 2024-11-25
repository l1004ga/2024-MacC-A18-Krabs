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
        
        self._isBeepSound = UserDefaults.standard.bool(forKey: "isBeepSound")
    }
    
    // 최초실행여부
    private var _didLaunchedBefore: Bool
    
    // 선택된 악기
    private var _selectedInstrument: Instrument
    
    // 비프음 여부
    private var _isBeepSound: Bool
}

extension AppState {
    var didLaunchedBefore: Bool { self._didLaunchedBefore }
    
    var selectedInstrument: Instrument { self._selectedInstrument }
    
    var isBeepSound: Bool { self._isBeepSound }
    
    func appLaunched() {
        self._didLaunchedBefore = true
        UserDefaults.standard.set(true, forKey: "didLaunchedBefore")
    }
    
    func setInstrument(_ instrument: Instrument) {
        self._selectedInstrument = instrument
        UserDefaults.standard.set(instrument.rawValue, forKey: "selectedInstrument")
    }
    
    func setBeepSound(_ isBeepSound: Bool) {
        self._isBeepSound = isBeepSound
        UserDefaults.standard.set(isBeepSound, forKey: "isBeepSound")
    }
}
