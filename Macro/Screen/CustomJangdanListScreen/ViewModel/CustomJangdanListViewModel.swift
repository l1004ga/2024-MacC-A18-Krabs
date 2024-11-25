//
//  CustomJangdanListViewModel.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

@Observable
class CustomJangdanListViewModel {
    typealias JangdanSimpleType = (type: Jangdan, name: String, lastUpdate: Date)
    
    private var templateUseCase: TemplateUseCase
    
    init(templateUseCase: TemplateUseCase) {
        self.templateUseCase = templateUseCase
    }
    
    struct State {
        var customJangdanList: [JangdanSimpleType] = []
    }
    
    private var _state: State = .init()
    var state: State { _state }
}

extension CustomJangdanListViewModel {
    enum Action {
        case fatchCustomJangdanData
        case deleteCustomJangdanData(jangdanName: String)
    }
    
    func effect(action: Action) {
        switch action {
        case .fatchCustomJangdanData:
            self._state.customJangdanList = templateUseCase.allCustomJangdanTemplate.map { jangdanEntity in
                return (jangdanEntity.jangdanType, jangdanEntity.name, .now)
            }
        case let .deleteCustomJangdanData(jangdanName):
            self.templateUseCase.deleteCustomJangdan(jangdanName: jangdanName)
        }
    }
}
