//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//
import Foundation
import SwiftUI
import Combine



let jangdanList: [JangdanEntity] = [
    JangdanEntity(
        name: "자진모리",
        bakCount: 12,
        daebak: 4,
        bpm: 140,
        daebakList: [
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
        ]
    ),
    JangdanEntity(
        name: "중모리",
        bakCount: 12,
        daebak: 4,
        bpm: 100,
        daebakList: [
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
        ]
    ),
    JangdanEntity(
        name: "굿거리",
        bakCount: 12,
        daebak: 4,
        bpm: 120,
        daebakList: [
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .weak])
        ]
    ),
    JangdanEntity(
        name: "세마치",
        bakCount: 9,
        daebak: 3,
        bpm: 130,
        daebakList: [
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.strong, .medium, .weak])
        ]
    ),
    JangdanEntity(
        name: "휘모리",
        bakCount: 12,
        daebak: 4,
        bpm: 180,
        daebakList: [
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
        ]
    )
]

// 장단을 불러와서 장단 엔티티형태로 온오프에 전달
// 비피엠, 강세를 각 유스케이스에서 받으면 바뀐 형태를 적용해서 장단 엔티티 형태로 온오프에 전달
// 템포유스케이스에서는 바뀔 템포의 정보를 받고 이를 통해 비피엠 변경
// 강세유스케이스에서는 바뀔 소박의 위치에 대한 정보를 받고 1탭에 대한 활동으로 간주하여 강세 변경

class TemplateUseCase: JangdanSelectInterface {
    
    // 장단 변경과 BPM 변경을 퍼블리싱하는 Subject
    private var jangdanSubject = PassthroughSubject<[Accent], Never>()
    private var bpmSubject = PassthroughSubject<Int, Never>()
    
    private var currentJangdan: JangdanEntity
    var currentJangdanName: String {
        return currentJangdan.name
    }
    var currentJangdanBpm: Int {
        get {
            return currentJangdan.bpm
        }
        set {
            currentJangdan.bpm = newValue
            if sobakOnOff {
                let sobak = self.currentJangdan.bakCount / self.currentJangdan.daebak
                bpmSubject.send(newValue * sobak)
            } else {
                bpmSubject.send(newValue)
            }
        }
    }
    var currentJangdanBakCount: Int {
        return currentJangdan.bakCount
    }
    
    var sobakOnOff: Bool
    
    init() {
        self.currentJangdan = JangdanEntity(name: "", bakCount: 0, daebak: 0, bpm: 0, daebakList: [])
        self.sobakOnOff = false
    }
    
    // JangdanSelectInterface에 필요한 퍼블리셔들
    var jangdanPublisher: AnyPublisher<[Accent], Never> {
        return jangdanSubject.eraseToAnyPublisher()
    }
    
    var bpmPublisher: AnyPublisher<Int, Never> {
        return bpmSubject.eraseToAnyPublisher()
    }
    
    // 장단 데이터에서 장단 정보를 불러오는 함수
    private func loadJangdanData(name: String) -> JangdanEntity? {
        // TODO: 추후 장단리스트 repository 처리 필요
        
        return jangdanList.first { $0.name == name }
    }
    
    // 불러온 정보를 수정할 수 있도록 변수에 저장
    func setJangdan(name: String) {
        if let jangdan = loadJangdanData(name: name) {
            self.currentJangdan = jangdan
            
            let oneDimensionalArray = convertToOneDimensionalArray(daebakList: currentJangdan.daebakList)
            jangdanSubject.send(oneDimensionalArray)
        }
        
    }
    
    func changeSobakOnOff() {
        self.sobakOnOff.toggle()
    }
    
    // 현재 위치의 강세를 탭할 때마다 순차적으로 변경되도록 도와주는 함수
    private func changeAccent(daebakIndex: Int, sobakIndex: Int) {
        var currentAccent = currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex]
        
        switch currentAccent {
        case .strong:
            currentAccent = .medium
        case .medium:
            currentAccent = .weak
        case .weak:
            currentAccent = .none
        case .none:
            currentAccent = .strong
        }
        
        // 강세 변경
        currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex] = currentAccent
        
        // 1차원 배열 강세리스트를 퍼블리싱
        let oneDimensionalArray = convertToOneDimensionalArray(daebakList: currentJangdan.daebakList)
        jangdanSubject.send(oneDimensionalArray)
    }
    
    // 2차원인 강세 리스트를 1차원 배열로 변경해주는 함수
    private func convertToOneDimensionalArray(daebakList: [JangdanEntity.Daebak]) -> [Accent] {
        if sobakOnOff { // 대박+소박 전체 강세 다보냄
            return daebakList.flatMap { $0.bakAccentList }
        } else { // 대박만 강세 정제
            return daebakList.compactMap { $0.bakAccentList.first }
        }
    }
    
}


extension TemplateUseCase: UpdateTempoInterface {
    
    func updateTempo(newBpm: Int) {
        self.currentJangdanBpm = newBpm
        
    }
}


extension TemplateUseCase: MoveNextAccentInterface {
    
    func moveNextAccent(daebakIndex: Int, sobakIndex: Int) {
        changeAccent(daebakIndex: daebakIndex, sobakIndex: sobakIndex)
    }
    
}

