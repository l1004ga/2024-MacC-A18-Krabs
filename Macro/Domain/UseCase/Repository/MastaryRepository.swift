//
//  MastaryRepository.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

import Foundation
import Combine

// viewModel <-> Implements(of UseCase)
protocol MasteryUseCase {
    func startRecord()
    func stopRecord()
}

//
class MasteryImplements {
    private var jangdanRepository: JangdanRepository
    private var masteryRepository: MasteryRepository
    private var startTime: Date!
    private var jangdan: Jangdan?
    private var totalScore: Int
    var _totalScore: Int {
        return totalScore
    }
    
    private var cancelbag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository, masteryRepository: MasteryRepository) {
        self.jangdanRepository = jangdanRepository
        self.masteryRepository = masteryRepository
        self.totalScore = 0
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdanEntity in
            guard let self else { return }
            self.jangdan = Jangdan(rawValue: jangdanEntity.name)
        }
        .store(in: &cancelbag)
    }
}

extension MasteryImplements: MasteryUseCase {
    
    func startRecord() {
        self.startTime = .now
    }
    
    func stopRecord() {
        let practiceTime = startTime.timeIntervalSinceNow
        guard let jangdan = self.jangdan else { return }
        self.masteryRepository.updateMastary(practiceTime: Int(practiceTime))
    }
    
    func fetchTotalMasteryScore() {

    }
}

// Implements(of UseCase) <-> MasteryDataSource
protocol MasteryRepository {
    func fetchJangdan() -> Int
    func updateMastary(practiceTime: Int) // 장단 update
}
//

class MasteryDataSource {
    
}
