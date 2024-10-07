//
//  TempoUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Foundation






class TempoUseCase {
    private var templateUseCase: UpdateTempoInterface
    private var changeBpm: Int
    
    init(templateUseCase: UpdateTempoInterface) {
        self.templateUseCase = templateUseCase
        self.changeBpm = 0
    }
    
    func updateTempo(newBpm: Int) {
        changeBpm = newBpm
        templateUseCase.updateTempo(newBpm: changeBpm)
    }
    
}

