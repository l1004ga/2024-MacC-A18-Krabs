//
//  TemplateImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

class TemplateImplement {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanRepository
    private var instrument: Instrument

    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
        self.instrument = .장구
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
    
    var allCustomJangdanTemplateNames: [String] {
        return jangdanRepository.fetchCustomJangdanNames(instrument: instrument.rawValue)
    }
    
    var allBasicJangdanTemplateNames: [String] {
        return jangdanRepository.fetchBasicJangdanNames(instrument: instrument.rawValue)
    }
    
    //MARK: 장단 고를때 악기까지 올 수 있도록 변경해야 함 예시로 .장구 넣어둠
    func setJangdan(jangdanName: String) {
        self.jangdanRepository.fetchJangdanData(jangdanName: jangdanName, instrument: instrument.rawValue)
    }
    
    // MARK: - Custom Template CRUD Logic
    func createCustomJangdan(newJangdanName: String) throws {
        guard self.jangdanRepository.isRepeatedName(jangdanName: newJangdanName) else {
            throw DataError.registedName
        }
        self.jangdanRepository.saveNewJangdan(newJangdanName: newJangdanName)
    }
    
    
    func editCustomJangdan(targetName: String, newData: JangdanEntity) throws {
        guard self.jangdanRepository.isRepeatedName(jangdanName: newData.name) else {
            throw DataError.registedName
        }
        self.jangdanRepository.updateJangdanTemplate(targetName: targetName, newJangdan: newData)
    }
    
    func deleteCustomJangdan(jangdanName: String) {
        self.jangdanRepository.deleteCustomJangdan(jangdanName: jangdanName)
    }
}
