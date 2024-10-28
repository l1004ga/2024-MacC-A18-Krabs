//
//  TapTapUseCase.swift
//  Macro
//
//  Created by Yunki on 10/28/24.
//

import Combine
import Foundation

class TapTapUseCase {
    private var startTime: Date
    private var tapCount: Int
    private var isTapping: Bool
    @Published private var lastTappedDate: Date
    
    private var isTappingSubject = PassthroughSubject<Bool, Never>()
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var tempoUseCase: ReflectTempoInterface
    
    init(tempoUseCase: ReflectTempoInterface) {
        self.startTime = .now
        self.tapCount = 0
        self.isTapping = false
        self.lastTappedDate = .now
        
        self.tempoUseCase = tempoUseCase
        
        $lastTappedDate
            .debounce(for: .seconds(6), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.finishTapping()
                self.isTappingSubject.send(self.isTapping)
            }
            .store(in: &cancelBag)
    }
}

// ViewModel에서 호출할 용도
extension TapTapUseCase {
    var isTappingPublisher: AnyPublisher<Bool, Never> {
        self.isTappingSubject.eraseToAnyPublisher()
    }
    
    func tap() {
        if !isTapping {
            self.startTime = .now
            isTapping = true
            self.isTappingSubject.send(self.isTapping)
        }
        self.tapCount += 1
        
        lastTappedDate = .now
        
        guard tapCount > 1 else { return }
        
        let currentTime: Date = .now
        let interval: TimeInterval = currentTime.timeIntervalSince(startTime)
        let tempo: Double = Double(tapCount - 1) / interval * 60
        self.tempoUseCase.reflectTempo(by: Int(tempo.rounded()))
    }
    
    func finishTapping() {
        self.isTapping = false
        self.isTappingSubject.send(self.isTapping)
        self.tapCount = 0
    }
}
