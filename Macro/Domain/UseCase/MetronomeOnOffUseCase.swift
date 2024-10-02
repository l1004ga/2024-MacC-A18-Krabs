//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Foundation

class MetronomeOnOffUseCase {
    private var jangdanAccentList: [Accent]
    private var bpm: Int
    private var currentBeat: Int
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .background) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / Double(bpm)
    }
    
    private var templateUseCase: JangdanSelectInterface
    private var beatDisplayUseCase: UpdateBeatDisplayInterface
    private var soundUseCase: PlaySoundInterface
    
    init(templateUseCase: JangdanSelectInterface, beatDisplayUseCase: UpdateBeatDisplayInterface, soundUseCase: PlaySoundInterface) {
        self.jangdanAccentList = []
        self.bpm = 120
        self.currentBeat = 0
        
        self.templateUseCase = templateUseCase
        self.beatDisplayUseCase = beatDisplayUseCase
        self.soundUseCase = soundUseCase
    }
}

// Play / Stop
extension MetronomeOnOffUseCase {
    func play() {
        // 데이터 갱신
        self.jangdanAccentList = templateUseCase.fetchJangdan()
        self.bpm = templateUseCase.fetchBPM()
        self.currentBeat = 0
        
        // Timer 설정
        if let timer { self.stop() }
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: self.interval)
        self.timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            self.timerHandler()
        }
        
        // Timer 실행
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    private func timerHandler() {
        let accent = jangdanAccentList[self.currentBeat % jangdanAccentList.count]
        
        Task {
            await self.beatDisplayUseCase.nextBeat()
        }
        
        Task {
            switch accent {
            case .none:
                break
            case .weak:
                await self.soundUseCase.beep("weak")
            case .medium:
                await self.soundUseCase.beep("medium")
            case .strong:
                await self.soundUseCase.beep("strong")
            }
        }
        
        currentBeat += 1
    }
}

// BPM 갱신
extension MetronomeOnOffUseCase {
    func updateBPM(to value: Int) {
        self.bpm = value
        // TODO: - 실행시켜보고 뭔가 이상하면 deadline 변경해볼것 [.now() + interval -> .now()]
        self.timer?.schedule(deadline: .now() + self.interval, repeating: self.interval)
    }
}
