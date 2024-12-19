//
//  HomeViewModel.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

import SwiftUI

@Observable
class HomeViewModel {
    
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    
    init(metronomeOnOffUseCase: MetronomeOnOffUseCase) {
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
    }
}

extension HomeViewModel {
    enum Action {
        case changeSoundType
    }
    
    func effect(action: Action) {
        switch action {
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        }
    }
}
