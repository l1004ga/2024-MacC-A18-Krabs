//
//  CustomJangdanListViewModel.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

@Observable
class CustomJangdanListViewModel {
    private var templateUseCase: TemplateUseCase
    
    init(templateUseCase: TemplateUseCase) {
        self.templateUseCase = templateUseCase
    }
    
    struct State {
        
    }
    
    private var _state: State = .init()
    var state: State { _state }
}

extension CustomJangdanListViewModel {
    enum Action {
        case fatchCustomJangdanData
    }
    
    func effect(action: Action) {
        switch action {
        case .fatchCustomJangdanData:
            break
        }
    }
}
