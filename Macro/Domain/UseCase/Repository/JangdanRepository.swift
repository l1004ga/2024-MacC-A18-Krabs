//
//  JangdanRepository.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

import Combine

protocol JangdanRepository {
    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> { get }
    
    // 모든 Custom 장단의 name을 배열로 반환 (HomeView용)
    func fetchAllCustomJangdanNames(instrument: String) -> [String]
    
    func fetchJangdanData(jangdanName: String)
    
    func updateBPM(bpm: Int)
    
    func updateAccents(daebakList: [JangdanEntity.Daebak])
    
    func isRepeatedName(jangdanName: String) -> Bool
    
    // MARK: - Custom Template CRUD Logic
    func saveNewJangdan(jangdan: JangdanEntity)
    
    func updateJangdanTemplate(targetName: String, newJangdan: JangdanEntity)
    
    func deleteCustomJangdan(target: JangdanEntity)
}
