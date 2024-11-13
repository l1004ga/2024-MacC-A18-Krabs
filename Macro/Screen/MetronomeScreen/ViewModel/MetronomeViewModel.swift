//
//  MetronomeViewModel.swift
//  Macro
//
//  Created by Yunki on 10/30/24.
//

import SwiftUI
import Combine

@Observable
class MetronomeViewModel {
    // TODO: - Repository는 ViewModel에서 직접적으로 사용하지 않도록 변경할것
    private var jangdanRepository: JangdanRepository
    
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    private var accentUseCase: AccentUseCase
    private var taptapUseCase: TapTapUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository, templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, tempoUseCase: TempoUseCase, accentUseCase: AccentUseCase, taptapUseCase: TapTapUseCase) {
        
        self.jangdanRepository = jangdanRepository
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.tempoUseCase = tempoUseCase
        self.accentUseCase = accentUseCase
        self.taptapUseCase = taptapUseCase
        
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self._state.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self._state.jangdanAccent = jangdan.daebakList.map { $0.bakAccentList }
            self._state.bpm = jangdan.bpm
            self._state.bakCount = jangdan.bakCount
            self._state.daebakCount = jangdan.daebakList.count
        }
        .store(in: &self.cancelBag)
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
    struct State {
        var currentJangdan: Jangdan?
        var jangdanAccent: [[Accent]] = []
        var bakCount: Int = 0
        var daebakCount: Int = 0
        var isSobakOn: Bool = false
        var isPlaying: Bool = false
        var currentSobak: Int = 0
        var currentDaebak: Int = 0
        var bpm: Int = 60
        var pendulumTrigger: Bool = false
        var isTapping: Bool = false
    }
    
    enum Action {
        case selectJangdan(jangdan: Jangdan)
        case changeSobakOnOff
        case changeIsPlaying
        case decreaseBpm // - button
        case increaseBpm // + button
        case changeAccent(daebak: Int, sobak: Int)
        case stopMetronome
        case estimateBpm
    }
    
    private func updateStatePerBak() {
        var nextSobak: Int = self._state.currentSobak
        var nextDaebak: Int = self._state.currentDaebak
        
        nextSobak += 1
        if nextSobak == self._state.jangdanAccent[nextDaebak].count {
            nextDaebak += 1
            if nextDaebak == self._state.jangdanAccent.count {
                nextDaebak = 0
            }
            nextSobak = 0
        }
        
        self._state.currentSobak = nextSobak
        self._state.currentDaebak = nextDaebak
        
        if self._state.currentSobak == 0 {
            self._state.pendulumTrigger.toggle()
        }
    }
    
    private func initialDaeSoBakIndex() {
        self._state.currentDaebak = self._state.jangdanAccent.count - 1
        self._state.currentSobak = self._state.jangdanAccent[self._state.currentDaebak].count - 1
    }
    
    func effect(action: Action) {
        switch action {
        case let .selectJangdan(jangdan):
            self._state.currentJangdan = jangdan
            self.templateUseCase.setJangdan(jangdan: jangdan)
            self.initialDaeSoBakIndex()
            self.taptapUseCase.finishTapping()
        case .changeSobakOnOff:
            self._state.isSobakOn.toggle()
            self.metronomeOnOffUseCase.changeSobak()
        case .changeIsPlaying:
            self.initialDaeSoBakIndex()
            self._state.isPlaying.toggle()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.play {
                    self.updateStatePerBak()
                }
            } else {
                self.metronomeOnOffUseCase.stop()
                self._state.pendulumTrigger = false
            }
        case .decreaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm - 1)
            self.taptapUseCase.finishTapping()
            
        case .increaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm + 1)
            self.taptapUseCase.finishTapping()
            
        case let .changeAccent(daebak, sobak):
            self.accentUseCase.moveNextAccent(daebakIndex: daebak, sobakIndex: sobak)
        case .stopMetronome: // 시트 변경 시 소리 중지를 위해 사용함
            self._state.isPlaying = false
            self.metronomeOnOffUseCase.stop()
            self._state.pendulumTrigger = false
        case .estimateBpm:
            self.taptapUseCase.tap()
        }
    }
}
