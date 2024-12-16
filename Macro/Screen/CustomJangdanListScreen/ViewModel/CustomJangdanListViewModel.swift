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
        case fetchCustomJangdanData
        case updateCustomJangdan(newJangdanName: String?)
        case deleteCustomJangdanData(jangdanName: String)
    }
    
    func effect(action: Action) {
        switch action {
        case .fetchCustomJangdanData:
            self._state.customJangdanList = templateUseCase.allCustomJangdanTemplate.map { jangdanEntity in
                return (jangdanEntity.jangdanType, jangdanEntity.name, jangdanEntity.createdAt ?? .now)
            }.sorted {
                $0.lastUpdate > $1.lastUpdate
            }
        case let .updateCustomJangdan(newJangdanName):
            self.templateUseCase.updateCustomJangdan(newJangdanName: newJangdanName)
        case let .deleteCustomJangdanData(jangdanName):
            self.templateUseCase.deleteCustomJangdan(jangdanName: jangdanName)
        }
    }
}
