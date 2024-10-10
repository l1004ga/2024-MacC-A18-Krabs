//
//  TempoUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Foundation


class TempoUseCase {
    private var templateUseCase: UpdateTempoInterface
    private var metronomeOnOffUseCase: RealTimeUpdateBPMInterface
    
    init(templateUseCase: UpdateTempoInterface, metronomeOnOffUseCase: RealTimeUpdateBPMInterface) {
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
    }
    
    func updateTempo(newBpm: Int) {
        // 사용자가 변경한 BPM을 각 장단별 데이터 객체에 저장 요청
        templateUseCase.updateTempo(newBpm: newBpm)
        // 사용자가 변경한 BPM을 재생되는 박자 소리 및 화면 변경 과정의 interval 측정에 실시간 반영을 요청
        metronomeOnOffUseCase.updateBPM(bpm: newBpm)
    }
}
