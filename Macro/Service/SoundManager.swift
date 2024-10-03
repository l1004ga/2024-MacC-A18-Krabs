//
//  SoundManager.swift
//  Macro
//
//  Created by Yunki on 10/3/24.
//

import AVFoundation

class SoundManager {
    private var weakSoundPlayer: AVAudioPlayer
    private var mediumSoundPlayer: AVAudioPlayer
    private var strongSoundPlayer: AVAudioPlayer
    
    private var player: AVAudioPlayer?
    
    init?() {
        // AudioSession 설정
        do {
            // Background, 무음모드에서도 소리나게 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SoundManager: 오디오 세션 설정 중 에러 발생 - \(error)")
            return nil
        }
        
        do {
            try configureSoundPlayers(weak: "beep_weak", medium: "beep_medium", strong: "beep_strong")
        } catch {
            return nil
        }
    }
    
    private func configureSoundPlayers(weak: String, medium: String, strong: String) throws {
        // TODO: - 파일 가져다 진짜 집어넣기
        guard let weakSoundURL = Bundle.main.url(forResource: weak, withExtension: "wav") else { throw InitializeError.soundPlayerCreationFailed }
        guard let mediumSoundURL = Bundle.main.url(forResource: medium, withExtension: "wav") else { throw InitializeError.soundPlayerCreationFailed }
        guard let strongSoundURL = Bundle.main.url(forResource: strong, withExtension: "wav") else { throw InitializeError.soundPlayerCreationFailed }
        
        guard let weakSoundPlayer = try? AVAudioPlayer(contentsOf: weakSoundURL) else { throw InitializeError.soundPlayerCreationFailed }
        guard let mediumSoundPlayer = try? AVAudioPlayer(contentsOf: mediumSoundURL) else { throw InitializeError.soundPlayerCreationFailed }
        guard let strongSoundPlayer = try? AVAudioPlayer(contentsOf: strongSoundURL) else { throw InitializeError.soundPlayerCreationFailed }
        
        self.weakSoundPlayer = weakSoundPlayer
        self.mediumSoundPlayer = mediumSoundPlayer
        self.strongSoundPlayer = strongSoundPlayer
    }
    
    enum InitializeError: Error {
        case soundPlayerCreationFailed
    }
}

extension SoundManager: PlaySoundInterface {
    func beep(_ accent: Accent) {
        switch accent {
        case .none:
            break
        case .weak:
            self.weakSoundPlayer.play()
        case .medium:
            self.mediumSoundPlayer.play()
        case .strong:
            self.strongSoundPlayer.play()
        }
    }
}
