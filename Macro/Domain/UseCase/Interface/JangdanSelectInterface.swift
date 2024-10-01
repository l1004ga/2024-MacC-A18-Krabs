//
//  JangdanSelectInterface.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

// 장단 선택하는 UseCase용
protocol JangdanSelectInterface {
    func fetchJangdan() -> [Accent]
    func fetchBPM() -> Int
}
