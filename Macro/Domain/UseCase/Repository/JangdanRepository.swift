//
//  JangdanRepository.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

import Combine
import Foundation


//enum DataError: Error {
//    case networkError
//    case typeError
//    case unknown
//}

protocol JangdanRepository {
    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> { get }

    func fetchJangdanData(jangdan: Jangdan)
    func updateBPM(bpm: Int)
    func updateAccents(daebakList: [JangdanEntity.Daebak])
    
//    func addJangdan(jangdanDTO: JangdanDTO) -> Result<Bool, DataError>
}

