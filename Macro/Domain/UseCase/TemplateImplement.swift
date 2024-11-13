//
//  TemplateImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

class TemplateImplement {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanRepository
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
    }
    
    enum DataError: Error {
        case registedName
    }
}

extension TemplateImplement: TemplateUseCase {
    var allDefaultJangdanTemplateNames: [String] {
        Jangdan.allCases.map { $0.name }
    }
    var allCustomJangdanTemplateNames: [String] {
        return jangdanRepository.fetchAllCustomJangdanNames()
    }
    
    func setJangdan(jangdanName: String) {
        self.jangdanRepository.fetchJangdanData(jangdanName: jangdanName)
    }
    
    // MARK: - Custom Template CRUD Logic
    func createCustomJangdan(newData: JangdanEntity) throws {
        guard self.jangdanRepository.isRepeatedName(jangdanName: newData.name) else {
            throw DataError.registedName
        }
        self.jangdanRepository.saveNewJangdan(jangdan: newData)
    }
    
    func editCustomJangdan(targetName: String, newData: JangdanEntity) throws {
        guard self.jangdanRepository.isRepeatedName(jangdanName: newData.name) else {
            throw DataError.registedName
        }
        self.jangdanRepository.updateJangdanTemplate(targetName: targetName, newJangdan: newData)
    }
    
    func deleteCustomJangdan(target: JangdanEntity) {
        self.jangdanRepository.deleteCustomJangdan(target: target)
    }
}
