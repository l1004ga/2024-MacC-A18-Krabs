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
    private var jangdanUISubject = PassthroughSubject<[[Accent]], Never>()
    // for MetronomeOnOffUseCase
    private var jangdanSubject = PassthroughSubject<[Accent], Never>()
    private var bpmSubject = PassthroughSubject<Int, Never>()
    
    private var currentJangdan: JangdanEntity
    
    var sobakOnOff: Bool
    
    init(jangdanRepository: JangdanDataInterface) {
        self.jangdanRepository = jangdanRepository
        self.currentJangdan = JangdanEntity(name: "", bakCount: 0, daebak: 0, bpm: 0, daebakList: [])
        self.sobakOnOff = false
        
        self.publishJangdanForUI()
        self.publishJangdanForPlay()
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
        if self.sobakOnOff {
            return currentJangdan.bakCount
        } else {
            return currentJangdan.daebak
        }
    }
    
    // ViewModel용 퍼블리셔
    var jangdanUIPublisher: AnyPublisher<[[Accent]], Never> {
        return jangdanUISubject.eraseToAnyPublisher()
    }
    
    // JangdanSelectInterface에 필요한 퍼블리셔들
    var jangdanPublisher: AnyPublisher<[Accent], Never> {
        return jangdanSubject.eraseToAnyPublisher()
    }
    
    var bpmPublisher: AnyPublisher<Int, Never> {
        return bpmSubject.eraseToAnyPublisher()
    }
    
    // 불러온 정보를 수정할 수 있도록 변수에 저장
    func setJangdan(jangdan: Jangdan) {
        if let jangdan = self.jangdanRepository.fetchJangdanData(jangdan: jangdan) {
            self.currentJangdan = jangdan
            
            self.publishJangdanForUI()
            self.publishJangdanForPlay()
            
            self.updateBPMBySobakStatus()
        }
    }
    
    // 사용자가 소박보기 On/Off 시 실행됨
    func changeSobakOnOff() {
        self.sobakOnOff.toggle()
        // 소박보기 On/Off에 따라 MetronomeUseCase로 보내는 [Accent] 조절
        self.publishJangdanForUI()
        self.publishJangdanForPlay()
        // 소박보기 On/Off에 따라 MetronomeUseCase로 보내는 BPM 조절
        self.updateBPMBySobakStatus()
    }
    
    // MetronomeOnOffUseCase의 Jangdan을 갱신시킬 때
    private func publishJangdanForPlay() {
        var jangdanForPlay: [Accent] = []
        if self.sobakOnOff { // 대박+소박 전체 강세 다보냄
            jangdanForPlay = self.currentJangdan.daebakList.flatMap { $0.bakAccentList }
        } else { // 대박만 강세 정제
            jangdanForPlay = self.currentJangdan.daebakList.compactMap { $0.bakAccentList.first }
        }
        self.jangdanSubject.send(jangdanForPlay)
    }
    
    // ViewModel의 Jangdan을 갱신시킬 때
    private func publishJangdanForUI() {
        var jangdanForUI: [[Accent]] = []
        if self.sobakOnOff {
            jangdanForUI = self.currentJangdan.daebakList.map { $0.bakAccentList }
        } else {
            jangdanForUI = self.currentJangdan.daebakList.map { $0.bakAccentList.prefix(1).map { $0 } }
        }
        
        self.jangdanUISubject.send(jangdanForUI)
    }
    
    // 1)사용자가 BPM 변경 시, 2)소박보기 On/Off 변경 시 BPM 실행됨
    private func updateBPMBySobakStatus() {
        if self.sobakOnOff {
            let sobak = self.currentJangdan.bakCount / self.currentJangdan.daebak
            self.bpmSubject.send(self.currentJangdanBpm * sobak)
        } else {
            self.bpmSubject.send(self.currentJangdanBpm)
        }
    }
    
    // 현재 위치의 강세를 탭할 때마다 순차적으로 변경되도록 도와주는 함수
    private func changeAccent(daebakIndex: Int, sobakIndex: Int) {
        let currentAccent = self.currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex]
        
        // 강세 변경
        self.currentJangdan.daebakList[daebakIndex].bakAccentList[sobakIndex] = currentAccent.nextAccent()
        
        // 1차원 배열 강세리스트를 퍼블리싱
        self.publishJangdanForUI()
        self.publishJangdanForPlay()
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
