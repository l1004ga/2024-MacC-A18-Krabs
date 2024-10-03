//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//
import Foundation

class TemplateUseCase {
    // 임시로 작성
    var jangdan = JangdanEntity(name: "", bakCount: 0, daebak: 0, bpm: 0, daebakList: [])
}

extension TemplateUseCase: UpdateTempoInterface {

    func updateTempo(newBpm: Int) {
        self.jangdan.bpm = newBpm
    }
}
