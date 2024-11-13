//
//  MasteryUseCase.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

protocol MasteryUseCase {
    var totalMasteryScore: Int { get }
    func startRecord()
    func stopRecord()
}
