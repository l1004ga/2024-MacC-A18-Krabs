//
//  TapTapUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol TapTapUseCase {
    var isTappingPublisher: AnyPublisher<Bool, Never> { get }
    func tap()
    func finishTapping()
}
