//
//  AccentUseCase.swift
//  Macro
//
//  Created by leejina on 10/7/24.
//

class AccentUseCase {
    private var templateUseCase: MoveNextAccentInterface
    
    init(templateUseCase: MoveNextAccentInterface) {
        self.templateUseCase = templateUseCase
    }
}

extension AccentUseCase {
    func moveNextAccent(daebakIndex: Int, sobakIndex: Int) {
        templateUseCase.moveNextAccent(daebakIndex: daebakIndex, sobakIndex: sobakIndex)
    }
}
