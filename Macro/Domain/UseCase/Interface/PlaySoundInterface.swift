//
//  PlaySoundInterface.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

// 소리내는 UseCase용
protocol PlaySoundInterface {
    // TODO: - async 여부 확인 필요
    func beep(_ sound: String) async
}
