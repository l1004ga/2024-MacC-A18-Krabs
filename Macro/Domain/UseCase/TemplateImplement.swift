//
//  TemplateImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Foundation

class TemplateImplement {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanRepository
    private var appState: AppState

    
    init(jangdanRepository: JangdanRepository, appState: AppState) {
        self.jangdanRepository = jangdanRepository
        self.appState = appState
    }
    
    enum DataError: Error {
        case registedName
    }
}

//MARK: 장단 고를때 악기까지 올 수 있도록 변경해야 함 예시로 .장구 넣어둠
extension TemplateImplement: TemplateUseCase {
    
    
    var allDefaultJangdanTemplateNames: [String] {
        Jangdan.allCases.map { $0.name }
    }
    
    var allCustomJangdanTemplate: [JangdanEntity] {
        return jangdanRepository.fetchAllCustomJangdan(instrument: self.appState.selectedInstrument)
    }
    
    //MARK: 장단 고를때 악기까지 올 수 있도록 변경해야 함 예시로 .장구 넣어둠
    func setJangdan(jangdanName: String) {
        self.jangdanRepository.fetchJangdanData(jangdanName: jangdanName)
    }
    
    // MARK: - Custom Template CRUD Logic
    func createCustomJangdan(newJangdanName: String) throws {
        guard self.jangdanRepository.isRepeatedName(jangdanName: newJangdanName) else {
            throw DataError.registedName
        }
        self.jangdanRepository.saveNewJangdan(newJangdanName: newJangdanName)
    }
    
    func updateCustomJangdan(newJangdanName: String?) {
        self.jangdanRepository.updateCustomJangdan(newJangdanName: newJangdanName)
    }
    
    func deleteCustomJangdan(jangdanName: String) {
        self.jangdanRepository.deleteCustomJangdan(jangdanName: jangdanName)
    }
}
