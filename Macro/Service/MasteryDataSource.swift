//
//  MasteryDataSource.swift
//  Macro
//
//  Created by leejina on 11/13/24.
//

import SwiftUI

class MasteryDataSource{
    @AppStorage("totalMasteryScore") var totalMasteryScore = 0
}

extension MasteryDataSource: MasteryRepository {
    func fetchTotalMasteryScore() -> Int {
        return self.totalMasteryScore
    }
    
    func updateMastary(practiceTime: Int) {
        self.totalMasteryScore += practiceTime
    }
}
