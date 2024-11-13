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


    func fetchJangdanData(jangdan: Jangdan)
    
//    func fetchBasicJangdans() -> [JangdanEntity]
//    func fetchCustomJangdans() -> [JangdanEntity]
//    func saveCustomJangdan(jangdan: JangdanDataModel) -> Result<Bool, DataError>
//    func deleteCustomJangdan(jangdan: JangdanDataModel) -> Result<Bool, DataError>
//    func updateCustomJangdan(jangdan: JangdanDataModel) -> Result<Bool, DataError>
    

    func updateBPM(bpm: Int)
    func updateAccents(daebakList: [JangdanEntity.Daebak])
}

