//
//  ExampleUseCase.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import Foundation

class ExampleUseCase {
    private let exampleService: ExampleInterface
    
    var entity: ExampleEntity = .init(name: "")
    
    var name: String {
        entity.name
    }
    
    init(exampleService: ExampleInterface) {
        self.exampleService = exampleService
    }
    
    func changeName() {
        entity.name = exampleService.fetchName()
    }
}
