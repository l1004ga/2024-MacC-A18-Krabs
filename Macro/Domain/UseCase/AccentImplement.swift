//
//  AccentImplement.swift
//  Macro
//
//  Created by leejina on 10/7/24.
//

import Combine

class AccentImplement {
    private var jangdanRepository: JangdanRepository
    private var daebakList: [[JangdanEntity.Daebak]]
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
        self.daebakList = []
        
        self.jangdanRepository.jangdanPublisher.sink { jangdanEntity in
            self.daebakList = jangdanEntity.daebakList
        }
        .store(in: &cancelBag)
    }
}

extension AccentImplement: AccentUseCase {
    func moveNextAccent(rowIndex: Int, daebakIndex: Int, sobakIndex: Int, to newAccent: Accent) {
        self.daebakList[rowIndex][daebakIndex].bakAccentList[sobakIndex] = newAccent
        self.jangdanRepository.updateAccents(daebakList: self.daebakList)
    }
}
