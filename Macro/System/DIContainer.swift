//
//  DIContainer.swift
//  Macro
//
//  Created by leejina on 11/7/24.
//

class DIContainer {
    
    func registerJangdanRepository() -> JangdanRepository {
        return JangdanDataSource()
    }
    
    func registerSoundManager() -> SoundManager {
        return SoundManager()!
    }
    
    func registerTemplateUseCase(jangdanRepository: JangdanRepository) -> TemplateUseCase {
        return  TemplateUseCase(jangdanRepository: jangdanRepository)
    }
    
    func registerTempoUseCase(jangdanRepository: JangdanRepository) -> TempoUseCase {
        return  TempoUseCase(jangdanRepository: jangdanRepository)
    }
    
    func registerMetronomeOnOffUseCase(jangdanRepository: JangdanRepository, soundManager: SoundManager) -> MetronomeOnOffUseCase {
        return MetronomeOnOffUseCase(jangdanRepository: jangdanRepository, soundManager: soundManager)
    }
    
    func registerAccentUseCase(jangdanRepository: JangdanRepository) -> AccentUseCase {
        return AccentUseCase(jangdanRepository: jangdanRepository)
    }
    
    func registerTaptapUseCase(tempoUseCase: TempoUseCase) -> TapTapUseCase {
        return TapTapUseCase(tempoUseCase: tempoUseCase)
    }
}
