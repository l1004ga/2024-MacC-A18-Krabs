//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//
import Foundation
import SwiftUI



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

class TemplateUseCase {
  var currentJangdanName: String
  var currentJangdanBpm: Int
  var currrntJangdanDaeBak: Int
  var currentJangdanBakCount: Int
  var currentJangdanDaebakList: [JangdanEntity.Daebak]
  var currentDaeBakIndex: Int
  var currentSoBakIndex: Int
  var currentAccent: Accent
  
  init() {
    self.currentJangdanName = ""
    self.currentJangdanBpm = 0
    self.currentJangdanBakCount = 0
    self.currrntJangdanDaeBak = 0
    self.currentDaeBakIndex = 0
    self.currentSoBakIndex = 0
    self.currentJangdanDaebakList = []
    self.currentAccent = .weak
  }
  
  // 장단 데이터에서 장단 정보를 불러오는 함수
  private func getJangdanData() -> JangdanEntity? {
    if let jangdan = jangdanList.first(where: {$0.name == currentJangdanName}) {
      return jangdan
      
    } else {
      return nil
    }
  }
  
  // 불러온 정보를 수정할 수 있도록 변수에 저장
  private func loadJangdanData() {
    if let jangdan = getJangdanData() {
      self.currentJangdanName = jangdan.name
      self.currentJangdanBakCount = jangdan.bakCount
      self.currrntJangdanDaeBak = jangdan.daebak
      self.currentJangdanBpm = jangdan.bpm
      self.currentJangdanDaebakList = jangdan.daebakList
    }
    
  }
  
}


extension TemplateUseCase: UpdateTempoInterface {
  
  func updateTempo(newBpm: Int) {
    self.currentJangdanBpm = newBpm
    
  }
}

