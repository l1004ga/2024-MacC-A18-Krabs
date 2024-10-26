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
    private var bpm: Double
    private var currentBeat: Int
    var isSobakOn: Bool
    
    var cancelBag: Set<AnyCancellable> = []
    var jangdanSubscription: AnyCancellable?
    var bpmSubscription: AnyCancellable?
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .userInteractive) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / Double(bpm)
    }
    
    private var templateUseCase: JangdanSelectInterface
    private var soundManager: PlaySoundInterface
    
    init(templateUseCase: JangdanSelectInterface, soundManager: PlaySoundInterface) {
        self.jangdan = [[.medium]]
        self.bpm = 60
        self.currentBeat = 0
        self.isSobakOn = false
        
        self.templateUseCase = templateUseCase
        self.soundManager = soundManager
        
        self.jangdanSubscription = templateUseCase.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.jangdan = jangdan
        }
        self.jangdanSubscription?.store(in: &self.cancelBag)
        self.bpmSubscription = templateUseCase.bpmPublisher.sink { [weak self] bpm in
            guard let self else { return }
            self.bpm = bpm
            // Timer의 schedule을 현재 변경된 bpm에 맞게 재설정
            self.timer?.schedule(deadline: .now() + self.interval, repeating: self.interval, leeway: .nanoseconds(1))
        }
        self.bpmSubscription?.store(in: &self.cancelBag)
    }
}

// Play / Stop
extension MetronomeOnOffUseCase {
    
    func changeSobak() {
        self.isSobakOn.toggle()
    }
        func play(_ tickHandler: @escaping () -> Void ) {
            // 데이터 갱신
            self.currentBeat = 0
            
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
            let accent: Accent = jangdanAccentList[self.currentBeat % jangdanAccentList.count]
            self.soundManager.beep(accent)
            self.currentBeat += 1
        }
    }
