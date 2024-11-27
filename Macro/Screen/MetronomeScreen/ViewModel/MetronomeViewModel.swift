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
    private var accentUseCase: AccentUseCase
    private var taptapUseCase: TapTapUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository, templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, tempoUseCase: TempoUseCase, accentUseCase: AccentUseCase, taptapUseCase: TapTapUseCase) {
        
        self.jangdanRepository = jangdanRepository
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.accentUseCase = accentUseCase
        self.taptapUseCase = taptapUseCase
        
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self._state.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self._state.jangdanAccent = jangdan.daebakList.map { $0.map { $0.bakAccentList } }
            self._state.currentJangdanType = jangdan.jangdanType
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
        var currentJangdanName: String?
        var currentJangdanType: Jangdan?
        var jangdanAccent: [[[Accent]]] = []
        var bakCount: Int = 0
        var daebakCount: Int = 0
        var isSobakOn: Bool = false
        var isPlaying: Bool = false
        var isTapping: Bool = false
        var currentSobak: Int = 0
        var currentDaebak: Int = 0
        var currentRow: Int = 0
    }
    
    enum Action {
        case selectJangdan(selectedJangdanName: String)
        case changeSobakOnOff
        case changeIsPlaying
        case changeAccent(row: Int, daebak: Int, sobak: Int, newAccent: Accent)
        case stopMetronome
        case estimateBpm
        case disableEstimateBpm
        case createCustomJangdan(newJangdanName: String)
        case initialJangdan
        case changeSoundType
    }
    
    private func updateStatePerBak() {
        var nextSobak: Int = self._state.currentSobak
        var nextDaebak: Int = self._state.currentDaebak
        var nextRow: Int = self._state.currentRow
        
        nextSobak += 1
        if nextSobak == self._state.jangdanAccent[nextRow][nextDaebak].count {
            nextDaebak += 1
            if nextDaebak == self._state.jangdanAccent[nextRow].count {
                nextRow += 1
                if nextRow == self._state.jangdanAccent.count {
                    nextRow = 0
                }
                nextDaebak = 0
            }
            nextSobak = 0
        }
        
        self._state.currentSobak = nextSobak
        self._state.currentDaebak = nextDaebak
        self._state.currentRow = nextRow
    }
    
    private func initialDaeSoBakIndex() {
        self._state.currentRow = self._state.jangdanAccent.count - 1
        self._state.currentDaebak = self._state.jangdanAccent[self._state.currentRow].count - 1
        self._state.currentSobak = self._state.jangdanAccent[self._state.currentRow][self._state.currentDaebak].count - 1
    }
    
    func effect(action: Action) {
        if case .estimateBpm = action { } else {
            self.taptapUseCase.finishTapping()
        }
        
        switch action {
        case let .selectJangdan(jangdanName):
            self._state.currentJangdanName = jangdanName
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
            self.initialDaeSoBakIndex()
            self.taptapUseCase.finishTapping()
            self._state.isSobakOn = false
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
            }
            
        case let .changeAccent(row, daebak, sobak, newAccent):
            self.accentUseCase.moveNextAccent(rowIndex: row, daebakIndex: daebak, sobakIndex: sobak, to: newAccent)
        case .stopMetronome: // 시트 변경 시 소리 중지를 위해 사용함
            self._state.isPlaying = false
            if self._state.isSobakOn {
                self._state.isSobakOn = false
                self.metronomeOnOffUseCase.changeSobak()
            }
            self.metronomeOnOffUseCase.stop()
        case .estimateBpm:
            self.taptapUseCase.tap()
        case .disableEstimateBpm:
            self.taptapUseCase.finishTapping()
        case let .createCustomJangdan(newJangdanName):
            // MARK: 추후 이름 중복 등으로 인해서 생성 실패 시 Error 받아서 사용자 알림 처리 필요
            try? self.templateUseCase.createCustomJangdan(newJangdanName: newJangdanName)
        case .initialJangdan:
            guard let currentJangdanName = self.state.currentJangdanName else { return }
            self.templateUseCase.setJangdan(jangdanName: currentJangdanName)
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        }
    }
}
