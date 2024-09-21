//
//  ExampleViewModel.swift
//  Macro
//
//  Created by Yunki on 9/22/24.
//

import Foundation

@Observable
class ExampleViewModel {
    private let exampleUseCase: ExampleUseCase = .init(exampleService: ExampleService())
    
    struct State {
        var name: String = "Name"
    }
    
    private var _state: State = .init()
    var state: State { return _state }
    
    enum Action {
        case tapButton
    }
    
    func effect(action: Action) {
        switch action {
        case .tapButton:
            doSomething()
        }
    }
    
    private func doSomething() {
        exampleUseCase.changeName()
        self._state.name = exampleUseCase.entity.name
    }
}
