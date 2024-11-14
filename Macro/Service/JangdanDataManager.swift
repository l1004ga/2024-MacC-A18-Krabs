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
            container = try ModelContainer(for: JangdanDataModel.self)
            context = ModelContext(container)
        } catch {
            print("ModelContainer 초기화 실패: \(error)")
            return nil
        }
    }
    
    private let basicJangdanData: [JangdanEntity] = [
        JangdanEntity(
            name: "진양",
            bakCount: 24,
            daebak: 24,
            bpm: 30,
            daebakList: [
                [JangdanEntity.Daebak(bakAccentList: [.strong]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]), JangdanEntity.Daebak(bakAccentList: [.strong])],
                [JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]), JangdanEntity.Daebak(bakAccentList: [.strong])],
                [JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]), JangdanEntity.Daebak(bakAccentList: [.weak])],
                [JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]), JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]), JangdanEntity.Daebak(bakAccentList: [.strong])]
            ],
            jangdanType: .진양,
            instrument: .장구
        ),
        JangdanEntity(
            name: "중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 80,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak])
            ]],
            jangdanType: .중모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "중중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 90,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak])
            ]],
            jangdanType: .중중모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "자진모리",
            bakCount: 12,
            daebak: 4,
            bpm: 100,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])
            ]],
            jangdanType: .자진모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "굿거리",
            bakCount: 12,
            daebak: 4,
            bpm: 70,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])
            ]],
            jangdanType: .굿거리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "동살풀이",
            bakCount: 8,
            daebak: 4,
            bpm: 80,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none])
            ]],
            jangdanType: .동살풀이,
            instrument: .장구
        ),
        JangdanEntity(
            name: "휘모리",
            bakCount: 4,
            daebak: 2,
            bpm: 200,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak])
            ]],
            jangdanType: .휘모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "엇모리",
            bakCount: 10,
            daebak: 4,
            bpm: 200,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none])
            ]],
            jangdanType: .엇모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "엇중모리",
            bakCount: 6,
            daebak: 6,
            bpm: 200,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak])
            ]],
            jangdanType: .엇중모리,
            instrument: .장구
        ),
        JangdanEntity(
            name: "세마치",
            bakCount: 9,
            daebak: 3,
            bpm: 80,
            daebakList: [[
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .medium, .none])
            ]],
            jangdanType: .세마치,
            instrument: .장구
        )
    ]
    
    private var publisher: PassthroughSubject<JangdanEntity, Never> = .init()
    
    private var currentJangdan: JangdanEntity = .init(name: "자진모리", bakCount: 0, daebak: 0, bpm: 0, daebakList: [[.init(bakAccentList: [.medium])]], jangdanType: .자진모리, instrument: .장구)
    
    private func mapToJangdanEntity(model: JangdanDataModel) -> JangdanEntity {
        
        let daebakList = model.daebakListStrings.map { accents in
            accents.map { accents in
                JangdanEntity.Daebak(bakAccentList: accents.compactMap { Accent.from(rawValue: $0) })
            }
        }
        return JangdanEntity(
            name: model.name,
            bakCount: model.bakCount,
            daebak: model.daebak,
            bpm: model.bpm,
            daebakList: daebakList,
            jangdanType: Jangdan(rawValue: model.jangdanType) ?? .진양,
            instrument: Instrument(rawValue: model.instrument) ?? .장구
        )
    }
    
    
}

extension JangdanDataManager: JangdanRepository {
    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func fetchJangdanData(jangdanName: String)  {
        
        if let selctJangdan = basicJangdanData.first(where: { $0.name == jangdanName }) {
            self.currentJangdan = selctJangdan
            publisher.send(currentJangdan)
        } else {
            
            let predicate = #Predicate<JangdanDataModel> { jangdan in
                jangdan.name == jangdanName
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            
            do {
                
                if let fetchedData = try context.fetch(descriptor).first {
                    let selctJangdan = mapToJangdanEntity(model: fetchedData)
                    self.currentJangdan = selctJangdan
                    publisher.send(currentJangdan)
                } else {
                    print("해당 이름의 장단을 찾을 수 없습니다.")
                }
            } catch {
                print("데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    func updateBPM(bpm: Int) {
        self.currentJangdan.bpm = bpm
        publisher.send(currentJangdan)
    }
    
    func updateAccents(daebakList: [[JangdanEntity.Daebak]]) {
        self.currentJangdan.daebakList = daebakList
        publisher.send(currentJangdan)
    }
    
    // MARK: 여기에 악기에 대한 정보는 들어가야 하지 않을까요 해당하는 악기의 커스텀 장단만 불러오도록
    func fetchAllCustomJangdanNames(instrument: String) -> [String] {
        let predicate = #Predicate<JangdanDataModel> { $0.instrument == instrument }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            let jangdanList = try context.fetch(descriptor)
            return jangdanList.map { $0.name }
        } catch {
            print("모든 커스텀 장단 이름을 가져오는 중 오류 발생: \(error.localizedDescription)")
            return []
        }
    }
    
    func isRepeatedName(jangdanName: String) -> Bool {
        // 기본 장단 데이터에서 이름 확인
        if basicJangdanData.contains(where: { $0.name == jangdanName }) {
            return true
        }
        // 데이터베이스에서 중복 확인
        let predicate = #Predicate<JangdanDataModel> { $0.name == jangdanName }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            let results = try context.fetch(descriptor)
            return !results.isEmpty
        } catch {
            print("중복 이름 확인 중 오류 발생: \(error.localizedDescription)")
            return true // 오류가 발생하면 기본적으로 중복된 것으로 간주
        }
    }
    
    func saveNewJangdan(jangdan: JangdanEntity) {
        let newJangdan = JangdanDataModel(
            name: jangdan.name,
            bakCount: jangdan.bakCount,
            daebak: jangdan.daebak,
            bpm: jangdan.bpm,
            daebakList: jangdan.daebakList.map { $0.map { $0.bakAccentList.map { $0.rawValue } } },
            jangdanType: jangdan.jangdanType.rawValue,
            instrument: jangdan.instrument.rawValue
        )
        
        context.insert(newJangdan)
        do {
            try context.save()
        } catch {
            print("새 장단 저장 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func updateJangdanTemplate(targetName: String, newJangdan: JangdanEntity) {
        let predicate = #Predicate<JangdanDataModel> { $0.name == targetName }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            if let model = try context.fetch(descriptor).first {
                model.name = newJangdan.name
                model.bakCount = newJangdan.bakCount
                model.daebak = newJangdan.daebak
                model.bpm = newJangdan.bpm
                model.daebakListStrings = newJangdan.daebakList.map { $0.map { $0.bakAccentList.map { $0.rawValue } } }
                model.jangdanType = newJangdan.jangdanType.rawValue
                model.instrument = newJangdan.instrument.rawValue
                
                try context.save()
                print("장단 업데이트가 완료되었습니다.")
            } else {
                print("업데이트할 장단을 찾을 수 없습니다.")
            }
        } catch {
            print("장단 업데이트 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func deleteCustomJangdan(target: JangdanEntity) {
        let targetName = target.name
        let predicate = #Predicate<JangdanDataModel> { jangdan in
            jangdan.name == targetName
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            if let model = try context.fetch(descriptor).first {
                context.delete(model)
                try context.save()
                print("장단 삭제가 완료되었습니다.")
            } else {
                print("삭제할 장단을 찾을 수 없습니다.")
            }
        } catch {
            print("장단 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
}
