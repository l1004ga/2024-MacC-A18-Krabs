//
//  Untitled.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

// 사용자가 설정한 bpm으로 업데이트 도와주는 UseCase용

protocol UpdateTempoInterface {
    func updateTempo(newBpm: Int)
}
