//
//  JangdanSwiftData.swift
//  Macro
//
//  Created by jhon on 11/11/24.
//

import SwiftData
import Foundation

@Model
final class JangdanDataModel {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var bakCount: Int
    var daebak: Int
    var bpm: Int
    var daebakList: [DaebakDataModel]
    var jangdanType: String

    init(name: String, bakCount: Int, daebak: Int, bpm: Int, daebakList: [DaebakDataModel], jangdanType: Jangdan) {
        self.id = UUID()
        self.name = name
        self.bakCount = bakCount
        self.daebak = daebak
        self.bpm = bpm
        self.daebakList = daebakList
        self.jangdanType = jangdanType.rawValue
    }
    
    // 열거형으로 변환 메서드
    var jangdanEnumType: Jangdan {
        return Jangdan(rawValue: jangdanType) ?? .커스텀
    }
}

@Model
final class DaebakDataModel {
    var bakAccentList: [String] // Accent 대신 String으로 저장

    init(bakAccentList: [Accent]) {
        self.bakAccentList = bakAccentList.map { $0.rawValue }
    }
    // 열거형으로 변환 메서드
    func getAccentList() -> [Accent] {
        return bakAccentList.compactMap { Accent(rawValue: $0) }
    }
}

