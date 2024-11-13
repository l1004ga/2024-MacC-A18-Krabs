//
//  JangdanSwiftData.swift
//  Macro
//
//  Created by jhon on 11/13/24.
//

import SwiftData
import Foundation


// JangdanDataModel 정의
@Model
final class JangdanDataModel {
    var id: UUID
    var name: String
    var bakCount: Int
    var daebak: Int
    var bpm: Int
    var jangdanType: String
    var daebakListStrings: [[String]]
    var instrument: String

    // 초기화 메서드
    init(name: String, bakCount: Int, daebak: Int, bpm: Int, daebakList: [[String]], jangdanType: Jangdan, instrument: String) {
        self.id = UUID()
        self.name = name
        self.bakCount = bakCount
        self.daebak = daebak
        self.bpm = bpm
        self.jangdanType = jangdanType.rawValue
        self.daebakListStrings = daebakList
        self.instrument = instrument
    }
}



@Model
final class JangdanPracticeTime {
    var jangdanType: String
    var practiceTime: Double

    init(jangdanType: String, practiceTime: Double) {
        self.jangdanType = jangdanType
        self.practiceTime = practiceTime
    }
}
