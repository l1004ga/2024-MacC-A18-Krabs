//
//  SoundManager.swift
//  Macro
//
//  Created by Yunki on 10/3/24.
//

import AudioToolbox

class SoundManager {
    var strongSound: SystemSoundID
    var mediumSound: SystemSoundID
    var weakSound: SystemSoundID
    
    init?() {
        self.weakSound = 0
        self.mediumSound = 1
        self.strongSound = 2
        
        // TODO: - 파일 가져다 진짜 집어넣기
//        guard let weakSoundURL = Bundle.main.url(forResource: "beep_weak", withExtension: "wav") else { nil }
//        guard let mediumSoundURL = Bundle.main.url(forResource: "beep_medium", withExtension: "wav") else { nil }
//        guard let strongSoundURL = Bundle.main.url(forResource: "beep_strong", withExtension: "wav") else { nil }
        
//        AudioServicesCreateSystemSoundID(weakSoundURL, &weakSound)
//        AudioServicesCreateSystemSoundID(mediumSoundURL, &mediumSound)
//        AudioServicesCreateSystemSoundID(strongSoundURL, &strongSound)
    }
}

extension SoundManager: PlaySoundInterface {
    func beep(_ accent: Accent) async {
        switch accent {
        case .none:
            break
        case .weak:
            AudioServicesPlayAlertSound(self.weakSound)
        case .medium:
            AudioServicesPlayAlertSound(self.mediumSound)
        case .strong:
            AudioServicesPlayAlertSound(self.strongSound)
        }
    }
}
