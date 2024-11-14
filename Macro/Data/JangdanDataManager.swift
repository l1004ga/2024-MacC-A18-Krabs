//
//  JangdanDataManager.swift
//  Macro
//
//  Created by jhon on 11/11/24.
//

import SwiftData
import Combine
import Foundation


final class JangdanDataManager {
    
    private let container: ModelContainer
    private let context: ModelContext
    
    init?() {
        do {
            container = try ModelContainer(for: JangdanDataModel.self, JangdanPracticeTime.self)
            context = ModelContext(container)
        } catch {
            print("ModelContainer 초기화 실패: \(error)")
            return nil
        }
    }
    
    let basicJangdanData: [JangdanDTO] = [
        JangdanDTO(
            name: "진양",
            bakCount: 24,
            daebak: 24,
            bpm: 30,
            deabakList: [
                ["strong"], ["weak"], ["weak"], ["weak"], ["strong"], ["strong"],
                ["weak"], ["weak"], ["weak"], ["weak"], ["strong"], ["strong"],
                ["weak"], ["weak"], ["weak"], ["weak"], ["strong"], ["weak"],
                ["weak"], ["weak"], ["weak"], ["weak"], ["strong"], ["strong"]
            ],
            jangdanType: "진양",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 80,
            deabakList: [
                ["strong", "weak", "weak"], ["weak", "medium", "medium"],
                ["weak", "weak", "strong"], ["weak", "weak", "weak"]
            ],
            jangdanType: "중모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "중중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 90,
            deabakList: [
                ["strong", "weak", "weak"], ["weak", "medium", "medium"],
                ["weak", "weak", "strong"], ["weak", "weak", "weak"]
            ],
            jangdanType: "중중모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "자진모리",
            bakCount: 12,
            daebak: 4,
            bpm: 100,
            deabakList: [
                ["strong", "none", "none"], ["weak", "none", "none"],
                ["weak", "none", "none"], ["weak", "none", "none"]
            ],
            jangdanType: "자진모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "굿거리",
            bakCount: 12,
            daebak: 4,
            bpm: 70,
            deabakList: [
                ["strong", "none", "weak"], ["medium", "none", "weak"],
                ["medium", "none", "weak"], ["medium", "none", "weak"]
            ],
            jangdanType: "굿거리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "동살풀이",
            bakCount: 8,
            daebak: 4,
            bpm: 80,
            deabakList: [
                ["strong", "none"], ["weak", "none"], ["weak", "none"], ["weak", "none"]
            ],
            jangdanType: "동살풀이",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "휘모리",
            bakCount: 4,
            daebak: 2,
            bpm: 200,
            deabakList: [
                ["strong", "weak"], ["strong", "weak"]
            ],
            jangdanType: "휘모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "엇모리",
            bakCount: 10,
            daebak: 4,
            bpm: 200,
            deabakList: [
                ["strong", "none", "weak"], ["medium", "none"],
                ["medium", "none", "strong"], ["weak", "none"]
            ],
            jangdanType: "엇모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "엇중모리",
            bakCount: 6,
            daebak: 6,
            bpm: 200,
            deabakList: [
                ["strong"], ["weak"], ["weak"], ["weak"], ["strong"], ["weak"]
            ],
            jangdanType: "엇중모리",
            instrument: "장구"
        ),
        JangdanDTO(
            name: "세마치",
            bakCount: 9,
            daebak: 3,
            bpm: 80,
            deabakList: [
                ["strong", "none", "none"], ["strong", "none", "medium"], ["strong", "medium", "none"]
            ],
            jangdanType: "세마치",
            instrument: "장구"
        )
    ]
    
    private var publisher: PassthroughSubject<JangdanEntity, Never> = .init()
    
    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    private var currentJangdan: JangdanEntity = .init(name: "", bakCount: 0, daebak: 0, bpm: 0, daebakList: [.init(bakAccentList: [.medium])])
    
    private func mapToJangdanEntity(dto: JangdanDTO) -> JangdanEntity {
        
        let daebakList = dto.deabakList.map { accents in
            JangdanEntity.Daebak(bakAccentList: accents.compactMap { Accent.from(rawValue: $0) })
        }
        
        return JangdanEntity(
            name: dto.name,
            bakCount: dto.bakCount,
            daebak: dto.daebak,
            bpm: dto.bpm,
            daebakList: daebakList
        )
    }
    
}

extension JangdanDataManager: JangdanRepository {
    func fetchJangdanData(jangdanName: String) {
        if let dto = basicJangdanData.first(where: { $0.name == jangdanName }) {
            self.currentJangdan = mapToJangdanEntity(dto: dto)
            publisher.send(currentJangdan)
        } else {
            print("해당 이름의 장단을 찾을 수 없습니다.")
        }
    }
    
    func updateBPM(bpm: Int) {
        self.currentJangdan.bpm = bpm
        publisher.send(currentJangdan)
    }
    
    func updateAccents(daebakList: [JangdanEntity.Daebak]) {
        self.currentJangdan.daebakList = daebakList
        publisher.send(currentJangdan)
    }
    
    func fetchAllCustomJangdanNames() -> [String] {
        return []
    }
    
    func isRepeatedName(jangdanName: String) -> Bool {
        return false
    }
    
    func saveNewJangdan(jangdan: JangdanEntity) {
        
    }
    
    func updateJangdanTemplate(targetName: String, newJangdan: JangdanEntity) {
        
    }
    
    func deleteCustomJangdan(target: JangdanEntity) {
        
    }
}


