//
//  BuiltInJangdanPracticeViewModel.swift
//  Macro
//
//  Created by leejina on 12/18/24.
//

import Foundation
import Combine

@Observable
class BuiltInJangdanPracticeViewModel {
    
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var cancelbag: Set<AnyCancellable> = []
    
    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase) {
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        
        self.templateUseCase.currentJangdanTypePublisher.sink { [weak self] jangdanType in
            guard let self else { return }
            self._state.currentJangdanType = jangdanType
        }
        .store(in: &cancelbag)
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
    struct State {
        var currentJangdanName: String?
        var currentJangdanType: Jangdan?
    }
}

extension BuiltInJangdanPracticeViewModel {
    enum Action {
        case initialJangdan
        case stopMetronome
        case createCustomJangdan(newJangdanName: String)
        case changeSoundType
    }
    
    func effect(action: Action) {
        switch action {
        case .initialJangdan:
            guard let currentJangdanName = self.state.currentJangdanName else { return }
            self.templateUseCase.setJangdan(jangdanName: currentJangdanName)
        case .stopMetronome:
            self.metronomeOnOffUseCase.stop()
        case let .createCustomJangdan(newJangdanName):
            try! self.templateUseCase.createCustomJangdan(newJangdanName: newJangdanName)
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        }
    }
}
