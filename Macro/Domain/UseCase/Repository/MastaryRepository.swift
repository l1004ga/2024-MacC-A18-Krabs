//
//  MastaryRepository.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

protocol MasteryRepository {
    func fetchTotalMasteryScore() -> Int
    func updateMastary(practiceTime: Int) // 장단 update
}
