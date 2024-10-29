//
//  TempoUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Foundation


class TempoUseCase {
    private var templateUseCase: UpdateTempoInterface
    
    init(templateUseCase: UpdateTempoInterface) {
        self.templateUseCase = templateUseCase
    }
    
    func updateTempo(newBpm: Int) {
        // 사용자가 변경한 BPM을 각 장단별 데이터 객체에 저장 요청
        switch newBpm {
        case ..<10:
            templateUseCase.updateTempo(newBpm: 10)
        case 10...200:
            templateUseCase.updateTempo(newBpm: newBpm)
        case 200...:
            templateUseCase.updateTempo(newBpm: 200)
        default :
            break
        }
    }
}

extension TempoUseCase: ReflectTempoInterface {
    func reflectTempo(by tempo: Int) {
        self.updateTempo(newBpm: tempo)
    }
}
