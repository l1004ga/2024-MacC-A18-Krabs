//
//  TapTapImplement.swift
//  Macro
//
//  Created by Yunki on 10/28/24.
//

import Combine
import Foundation

class TapTapImplement {
    private var isTapping: Bool
    @Published private var lastTappedDate: Date
    private var timeStampList: [Date] = []
    
    private var isTappingSubject = PassthroughSubject<Bool, Never>()
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var tempoUseCase: ReflectTempoInterface
    
    init(tempoUseCase: ReflectTempoInterface) {
        self.isTapping = false
        self.lastTappedDate = .now
        self.timeStampList = []
        
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
extension TapTapImplement {
    var isTappingPublisher: AnyPublisher<Bool, Never> {
        self.isTappingSubject.eraseToAnyPublisher()
    }
    
    func tap() {
        if !isTapping {
            isTapping = true
            self.isTappingSubject.send(self.isTapping)
        }
      
        lastTappedDate = .now
        self.timeStampList.append(lastTappedDate)
        
        if timeStampList.count > 5 {
            self.timeStampList.removeFirst()
        }
        
        guard timeStampList.count > 1 else { return }
        
        let interval: TimeInterval = timeStampList.last!.timeIntervalSince(timeStampList.first!)
        let averageInterval: TimeInterval = interval / Double(timeStampList.count - 1)
        let tempo: Double = 60 / averageInterval
        self.tempoUseCase.reflectTempo(by: Int(tempo.rounded()))
    }
    
    func finishTapping() {
        self.isTapping = false
        self.isTappingSubject.send(self.isTapping)
        self.timeStampList.removeAll()
    }
}
