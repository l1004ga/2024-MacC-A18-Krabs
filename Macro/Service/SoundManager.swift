//
//  SoundManager.swift
//  Macro
//
//  Created by Yunki on 10/3/24.
//

import AVFoundation

class SoundManager {
    private var engine: AVAudioEngine
    private var weakSoundPlayerNode: AVAudioPlayerNode
    private var mediumSoundPlayerNode: AVAudioPlayerNode
    private var strongSoundPlayerNode: AVAudioPlayerNode
    private var audioBuffers: [Accent: AVAudioPCMBuffer] = [:]

    init?() {
        self.engine = AVAudioEngine()
        self.weakSoundPlayerNode = AVAudioPlayerNode()
        self.mediumSoundPlayerNode = AVAudioPlayerNode()
        self.strongSoundPlayerNode = AVAudioPlayerNode()

        // AudioSession 설정
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SoundManager: 오디오 세션 설정 중 에러 발생 - \(error)")
            return nil
        }

        do {
            // 사운드 파일을 설정
            try configureSoundPlayers(weak: "beep_weak", medium: "beep_medium", strong: "beep_strong")
        } catch {
            return nil
        }

        // PlayerNode를 엔진에 연결
        self.engine.attach(self.weakSoundPlayerNode)
        self.engine.attach(self.mediumSoundPlayerNode)
        self.engine.attach(self.strongSoundPlayerNode)

        // 엔진의 메인 믹서에 연결
        let mainMixer = self.engine.mainMixerNode
        self.engine.connect(self.weakSoundPlayerNode, to: mainMixer, format: nil)
        self.engine.connect(self.mediumSoundPlayerNode, to: mainMixer, format: nil)
        self.engine.connect(self.strongSoundPlayerNode, to: mainMixer, format: nil)

        // 오디오 엔진 시작
        do {
            try self.engine.start()
        } catch {
            print("SoundManager: 오디오 엔진 시작 중 에러 발생 - \(error)")
            return nil
        }
    }

    private func configureSoundPlayers(weak: String, medium: String, strong: String) throws {
        // 오디오 파일을 로드하고, AVAudioPCMBuffer로 변환하여 저장
        guard let weakBuffer = try? loadAudioFile(weak),
              let mediumBuffer = try? loadAudioFile(medium),
              let strongBuffer = try? loadAudioFile(strong) else {
            throw InitializeError.soundPlayerCreationFailed
        }

        self.audioBuffers[.weak] = weakBuffer
        self.audioBuffers[.medium] = mediumBuffer
        self.audioBuffers[.strong] = strongBuffer
    }

    private func loadAudioFile(_ resource: String) throws -> AVAudioPCMBuffer {
        guard let fileURL = Bundle.main.url(forResource: resource, withExtension: "wav") else {
            throw InitializeError.soundPlayerCreationFailed
        }

        let audioFile = try AVAudioFile(forReading: fileURL)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            throw InitializeError.soundPlayerCreationFailed
        }

        try audioFile.read(into: buffer)
        return buffer
    }

    enum InitializeError: Error {
        case soundPlayerCreationFailed
    }
}

// Sound Set 변경
extension SoundManager {
    enum SoundType: String {
        case beep
    }

    func setSoundType(to type: SoundType) {
        do {
            try self.configureSoundPlayers(weak: "\(type.rawValue)_weak", medium: "\(type.rawValue)_medium", strong: "\(type.rawValue)_strong")
        } catch {
            print("SoundManager: Sound Type 변경 실패 - \(error)")
        }
    }
}

extension SoundManager: PlaySoundInterface {
    func beep(_ accent: Accent) {
        guard let buffer = self.audioBuffers[accent] else { return }

        switch accent {
        case .none:
            break
        case .weak:
            self.weakSoundPlayerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
            self.weakSoundPlayerNode.play()
        case .medium:
            self.mediumSoundPlayerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
            self.mediumSoundPlayerNode.play()
        case .strong:
            self.strongSoundPlayerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
            self.strongSoundPlayerNode.play()
        }
    }
}
