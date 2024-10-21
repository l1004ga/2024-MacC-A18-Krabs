//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//
import Foundation
import SwiftUI
import Combine

// 장단을 불러와서 장단 엔티티형태로 온오프에 전달
// 비피엠, 강세를 각 유스케이스에서 받으면 바뀐 형태를 적용해서 장단 엔티티 형태로 온오프에 전달
// 템포유스케이스에서는 바뀔 템포의 정보를 받고 이를 통해 비피엠 변경
// 강세유스케이스에서는 바뀔 소박의 위치에 대한 정보를 받고 1탭에 대한 활동으로 간주하여 강세 변경

class TemplateUseCase: JangdanSelectInterface {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanDataInterface
    
    // 장단 변경과 BPM 변경을 퍼블리싱하는 Subject
    // for ViewModel
    private var bpmUISubject = PassthroughSubject<Int, Never>()
    // for MetronomeOnOffUseCase
    private var jangdanSubject = PassthroughSubject<[[Accent]], Never>()
    private var bpmSubject = PassthroughSubject<Double, Never>()
    
    private var currentJangdan: JangdanEntity
    
    init(jangdanRepository: JangdanDataInterface) {
        self.jangdanRepository = jangdanRepository
        self.currentJangdan = JangdanEntity(name: "", bakCount: 0, daebak: 0, bpm: 0, daebakList: [])
        self.publishJangdan()
    }
    
    var currentJangdanName: String {
        return currentJangdan.name
    }
    
    var currentJangdanBpm: Int {
        get {
            return self.currentJangdan.bpm
        }
        set {
            self.currentJangdan.bpm = newValue
            self.updateBPMBySobakStatus()
        }
    }
    
    var currentJangdanBakCount: Int {
            return currentJangdan.bakCount
    }
    
    var currentJangdanDaebakCount: Int {
        return currentJangdan.daebak
    }
    
    var bpmUIPublisher: AnyPublisher<Int, Never> {
        return bpmUISubject.eraseToAnyPublisher()
    }

    var jangdanPublisher: AnyPublisher<[[Accent]], Never> {
        return jangdanSubject.eraseToAnyPublisher()
    }
    
    var bpmPublisher: AnyPublisher<Double, Never> {
        return bpmSubject.eraseToAnyPublisher()
    }
    
    // 불러온 정보를 수정할 수 있도록 변수에 저장
    func setJangdan(jangdan: Jangdan) {
        if let jangdan = self.jangdanRepository.fetchJangdanData(jangdan: jangdan) {
            self.currentJangdan = jangdan
            
            self.publishJangdan()
            self.updateBPMBySobakStatus()
        }
    }

    // ViewModel의 Jangdan을 갱신시킬 때
    private func publishJangdan() {
        var publishedJangdan: [[Accent]] = []
        publishedJangdan = self.currentJangdan.daebakList.map { $0.bakAccentList }

        self.jangdanSubject.send(publishedJangdan)
    }
    
    // 1)사용자가 BPM 변경 시, 2)소박보기 On/Off 변경 시 BPM 실행됨
    private func updateBPMBySobakStatus() {
        let sobak = Double(self.currentJangdan.bakCount) / Double(self.currentJangdan.daebak)
        self.bpmSubject.send(Double(self.currentJangdanBpm) * sobak)
        self.bpmUISubject.send(self.currentJangdanBpm)
    }
    
    // 현재 위치의 강세를 탭할 때마다 순차적으로 변경되도록 도와주는 함수
    private func changeAccent(daebakIndex: Int, sobakIndex: Int) {
        let currentAccent = self.currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex]
        
        // 강세 변경
        self.currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex] = currentAccent.nextAccent()
        
        // 1차원 배열 강세리스트를 퍼블리싱
        self.publishJangdan()
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
