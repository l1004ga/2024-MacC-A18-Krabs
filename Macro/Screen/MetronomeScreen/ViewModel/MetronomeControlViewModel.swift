//
//  MetronomeControlViewModel.swift
//  Macro
//
//  Created by Lee Wonsun on 11/19/24.
//

import SwiftUI
import Combine

class MetronomeControlViewModel {
    
    private var cancelBag: Set<AnyCancellable> = []
    private var jangdanRepository: JangdanRepository
    private var taptapUseCase: TapTapUseCase
    private var tempoUseCase: TempoUseCase
    
    var isMinusActive: Bool
    var isPlusActive: Bool
    var previousTranslation: CGFloat
    var timerCancellable: AnyCancellable?
    var speed: TimeInterval
    var isTapping: Bool
    var bpm: Int
    
    init(jangdanRepository: JangdanRepository, taptapUseCase: TapTapUseCase, tempoUseCase: TempoUseCase) {
        self.jangdanRepository = jangdanRepository
        self.taptapUseCase = taptapUseCase
        self.tempoUseCase = tempoUseCase
        
        self.isPlusActive = false
        self.isMinusActive = false
        self.previousTranslation = .zero
        self.timerCancellable = nil
        self.speed = 0.5
        self.isTapping = false
        self.bpm = 60
        
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.bpm = jangdan.bpm
        }
        .store(in: &self.cancelBag)
    }
    
    enum ControllerAction {
        case decreaseShortBpm
        case decreaseLongBpm(roundedBpm: Int)
        case increaseShortBpm
        case increaseLongBpm(roundedBpm: Int)
        case roundBpm(currentBpm: Int)
        case estimateBpm
    }
    
    func effect(action: ControllerAction) {
        switch action {
        case .decreaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self.bpm - 1)
            self.taptapUseCase.finishTapping()
        case let .decreaseLongBpm(roundedBpm):
            self.tempoUseCase.updateTempo(newBpm: roundedBpm - 10)
            self.taptapUseCase.finishTapping()
        case .increaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self.bpm + 1)
            self.taptapUseCase.finishTapping()
        case let .increaseLongBpm(roundedBpm):
            self.tempoUseCase.updateTempo(newBpm: roundedBpm + 10)
            self.taptapUseCase.finishTapping()
        case let .roundBpm(currentBpm):
            self.tempoUseCase.updateTempo(newBpm: currentBpm)
        case .estimateBpm:
            self.taptapUseCase.tap()
        }
    }
}


