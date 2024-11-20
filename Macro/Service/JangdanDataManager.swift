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
    private let basicJangdanData = BasicJangdanData.all
    
    init?() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: JangdanDataModel.self, configurations: config)
            context = ModelContext(container)
        } catch {
            print("ModelContainer 초기화 실패: \(error)")
            return nil
        }
    }

    private var publisher: PassthroughSubject<JangdanEntity, Never> = .init()
    private var currentJangdan: JangdanEntity = .init(name: "자진모리", bakCount: 0, daebak: 0, bpm: 0, daebakList: [[.init(bakAccentList: [.medium])]], jangdanType: .자진모리, instrument: .장구)
    
    private func convertToDaebakList(from daebakListStrings: [[[String]]]) -> [[JangdanEntity.Daebak]] {
        return daebakListStrings.map { daebak in
            daebak.map { sobak in
                JangdanEntity.Daebak(bakAccentList: sobak.compactMap { Accent.from(rawValue: $0) })
            }
        }
    }

    private func mapToJangdanEntity(model: JangdanDataModel) -> JangdanEntity {
        return JangdanEntity(
            name: model.name,
            bakCount: model.bakCount,
            daebak: model.daebak,
            bpm: model.bpm,
            daebakList: convertToDaebakList(from: model.daebakListStrings),
            jangdanType: Jangdan(rawValue: model.jangdanType) ?? .진양,
            instrument: Instrument(rawValue: model.instrument) ?? .장구
        )
    }
    
}

extension JangdanDataManager: JangdanRepository {

    var jangdanPublisher: AnyPublisher<JangdanEntity, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func fetchBasicJangdan(jangdanName: String, instrument: String) -> JangdanEntity? {
        return basicJangdanData.first { $0.name == jangdanName && $0.instrument == Instrument(rawValue: instrument)}
    }

    func fetchCustomJangdan(jangdanName: String, instrument: String) -> JangdanEntity? {
        let predicate = #Predicate<JangdanDataModel> {
            $0.name == jangdanName && $0.instrument == instrument
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            if let model = try context.fetch(descriptor).first {
                return mapToJangdanEntity(model: model)
            }
        } catch {
            print("데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
        }
        return nil
    }

    func fetchJangdanData(jangdanName: String, instrument: String) {
        if let jangdan = fetchBasicJangdan(jangdanName: jangdanName, instrument: instrument) ??
                         fetchCustomJangdan(jangdanName: jangdanName, instrument: instrument) {
            self.currentJangdan = jangdan
            publisher.send(currentJangdan)
        } else {
            print("해당 이름과 악기에 맞는 장단을 찾을 수 없습니다.")
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
    
    func fetchBasicJangdanNames(instrument: String) -> [String] {
        let jangdanList = basicJangdanData
            .filter { $0.instrument == Instrument(rawValue: instrument) }
            .map { $0.name }
        
        if jangdanList.isEmpty {
            print("기본 장단 이름 가져오기 실패: 해당 악기에 맞는 데이터가 없습니다.")
            return []
        }
        
        return jangdanList
    }
    // MARK: 여기에 악기에 대한 정보는 들어가야 하지 않을까요 해당하는 악기의 커스텀 장단만 불러오도록
    func fetchCustomJangdanNames(instrument: String) -> [String] {
        let predicate = #Predicate<JangdanDataModel> { $0.instrument == instrument}
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
    
    func saveNewJangdan(newJangdanName: String) {
        let newJangdan = JangdanDataModel(
            name: newJangdanName,
            bakCount: currentJangdan.bakCount,
            daebak: currentJangdan.daebak,
            bpm: currentJangdan.bpm,
            daebakList: currentJangdan.daebakList.map { $0.map { $0.bakAccentList.map { String($0.rawValue) } } },
            jangdanType: currentJangdan.jangdanType.rawValue,
            instrument: currentJangdan.instrument.rawValue
        )
        context.insert(newJangdan)
        
        do {
            try context.save()
        } catch {
            print("새 장단 저장 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func deleteCustomJangdan(jangdanName: String) {
        let predicate = #Predicate<JangdanDataModel> { jangdan in
            jangdan.name == jangdanName
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
