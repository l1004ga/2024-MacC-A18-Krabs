//
//  MasteryUseCase.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

// MARK: 숙련도 기능 미사용
protocol MasteryUseCase {
    var totalMasteryScore: Int { get }
    func startRecord()
    func stopRecord()
}
