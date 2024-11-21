//
//  JangdanRepository.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

import Combine
import Foundation

protocol JangdanRepository {
    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> { get }
    
    func fetchCustomJangdanNames(instrument: String) -> [String]
    func fetchBasicJangdanNames(instrument: String) -> [String]
    func fetchJangdanData(jangdanName: String)

    func updateBPM(bpm: Int)
    func updateAccents(daebakList: [[JangdanEntity.Daebak]])
    
    func isRepeatedName(jangdanName: String) -> Bool
    
    // MARK: - Custom Template CRUD Logic
    func saveNewJangdan(newJangdanName: String)

    func deleteCustomJangdan(jangdanName: String)
}
