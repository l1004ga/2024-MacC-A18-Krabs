//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Foundation
import Combine

class MetronomeOnOffUseCase {
    private var jangdan: [[Accent]]
    private var jangdanAccentList: [Accent] {
        if self.isSobakOn {
            return jangdan.flatMap { $0 }
        } else {
            return jangdan.map { $0.enumerated().map { $0.offset == 0 ? $0.element : .none }}.flatMap { $0 }
        }
    }
    private var bpm: Int
    private var currentBeatIndex: Int
    var isSobakOn: Bool
    
    var cancelBag: Set<AnyCancellable> = []
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .userInteractive) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / Double(bpm)
    }
    
    private var jangdanRepository: JangdanRepository
    private var soundManager: PlaySoundInterface
    
    init(jangdanRepository: JangdanRepository, soundManager: PlaySoundInterface) {
        self.jangdan = [[.medium]]
        self.bpm = 60
        self.currentBeatIndex = 0
        self.isSobakOn = false
        
        self.jangdanRepository = jangdanRepository
        self.soundManager = soundManager
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdanEntity in
            guard let self else { return }
            self.jangdan = jangdanEntity.daebakList.map { $0.bakAccentList }
            
            self.bpm = jangdanEntity.bpm
            self.timer?.schedule(deadline: .now() + self.interval, repeating: self.interval, leeway: .nanoseconds(1))
        }
        .store(in: &self.cancelBag)
    }
}

// Play / Stop
extension MetronomeOnOffUseCase {
    
    func changeSobak() {
        self.isSobakOn.toggle()
    }
    
    func play(_ tickHandler: @escaping () -> Void ) {
        // 데이터 갱신
        self.currentBeatIndex = 0
        
        // Timer 설정
        if let timer { self.stop() }
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: self.interval)
        self.timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            tickHandler()
            self.timerHandler()
        }
        
        // Timer 실행
        self.timer?.resume()
    }
    
    func stop() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func timerHandler() {
        let accent: Accent = jangdanAccentList[self.currentBeatIndex % jangdanAccentList.count]
        self.soundManager.beep(accent)
        self.currentBeatIndex += 1
    }
}
