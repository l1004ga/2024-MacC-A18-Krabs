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
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    private var accentUseCase: AccentUseCase
    private var taptapUseCase: TapTapUseCase
    
    private var jangdanUISubscriber: AnyCancellable?
    private var bpmSubscriber: AnyCancellable?
    private var cancelBag: Set<AnyCancellable> = []
    
    init() {
        let initTemplateUseCase = TemplateUseCase(jangdanRepository: JangdanRepository())
        self.templateUseCase = initTemplateUseCase
        let initSoundManager: SoundManager? = .init()
        // TODO: SoundManager 에러처리하고 언래핑 풀어주기~
        self.metronomeOnOffUseCase = MetronomeOnOffUseCase(templateUseCase: initTemplateUseCase, soundManager: initSoundManager!)
        
        let initTempoUseCase = TempoUseCase(templateUseCase: initTemplateUseCase)
        
        self.tempoUseCase = initTempoUseCase
        self.accentUseCase = AccentUseCase(templateUseCase: initTemplateUseCase)
        self.taptapUseCase = TapTapUseCase(tempoUseCase: initTempoUseCase)
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self._state.isTapping = isTapping
        }.store(in: &self.cancelBag)
        
        self.jangdanUISubscriber = self.templateUseCase.jangdanPublisher.sink { [weak self] jangdanUI in
            guard let self else { return }
            self._state.jangdanAccent = jangdanUI
            self.initialDaeSoBakIndex()
        }
        self.jangdanUISubscriber?.store(in: &self.cancelBag)
        self.bpmSubscriber = self.templateUseCase.bpmUIPublisher.sink { [weak self] bpm in
            guard let self else { return }
            self._state.bpm = bpm
        }
        self.bpmSubscriber?.store(in: &self.cancelBag)
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
            self._state.bakCount = self.templateUseCase.currentJangdanBakCount
            self._state.daebakCount = self.templateUseCase.currentJangdanDaebakCount
            self.taptapUseCase.finishTapping()
        case .changeSobakOnOff:
            self._state.isSobakOn.toggle()
            self.metronomeOnOffUseCase.changeSobak()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.stop()
                self.initialDaeSoBakIndex()
                self._state.pendulumTrigger = false
                self.metronomeOnOffUseCase.play {
                    self.updateStatePerBak()
                }
            }
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
