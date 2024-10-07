//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//
import Foundation



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



class TemplateUseCase {
  var currentJangdanName : String
  var currentJangdanbakCount : Int
  var currentJangdanDaebak : Int
  var currentJangdanBpm : Int
  
  
  init() {
    self.currentJangdanName = "장단"
    self.currentJangdanbakCount = 0
    self.currentJangdanDaebak = 0
    self.currentJangdanBpm = 0
  }
  
  private func getJangdanData() -> JangdanEntity? {
    if let jangdan = jangdanList.first(where: {$0.name == currentJangdanName}) {
      return jangdan
      
    } else {
      return nil
    }
    
  }
    
  
}


extension TemplateUseCase: UpdateTempoInterface {

    func updateTempo(newBpm: Int) {
        
    }
}

