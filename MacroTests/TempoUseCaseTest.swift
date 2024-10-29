//
//  TempoUseCaseTest.swift
//  TempoUseCaseTest
//
//  Created by Yunki on 9/21/24.
//

import Testing
@testable import Macro

struct TempoUseCaseTest {

    let tempoUseCase: UpdateTempoInterface
    
    init(tempoUseCase: UpdateTempoInterface) {
        self.tempoUseCase = tempoUseCase
    }
    
    @Test func example() {
        let result = tempoUseCase.updateTempo(newBpm: <#T##Int#>)
    }

}
