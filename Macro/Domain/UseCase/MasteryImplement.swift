//
//  MasteryImplement.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

import Foundation
import Combine

class MasteryImplement {
    private var jangdanRepository: JangdanRepository
    private var masteryRepository: MasteryRepository
    private var startTime: Date!
    private var jangdan: Jangdan?
    
    private var cancelbag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository, masteryRepository: MasteryRepository) {
        self.jangdanRepository = jangdanRepository
        self.masteryRepository = masteryRepository
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdanEntity in
            guard let self else { return }
            self.jangdan = Jangdan(rawValue: jangdanEntity.name)
        }
        .store(in: &cancelbag)
    }
}

extension MasteryImplement: MasteryUseCase {
    
    var totalMasteryScore: Int {
        return self.masteryRepository.fetchTotalMasteryScore()
    }
    
    func startRecord() {
        self.startTime = .now
    }
    
    func stopRecord() {
        let practiceTime = startTime.timeIntervalSinceNow
        guard let jangdan = self.jangdan else { return }
        self.masteryRepository.updateMastary(practiceTime: Int(practiceTime))
    }
}
