//
//  DIContainer.swift
//  Macro
//
//  Created by leejina on 11/7/24.
//

class DIContainer {
    
    static let shared: DIContainer = DIContainer()
    
    private init() {
        self._jangdanDataSource = .init()
        self._soundManager = .init()!
        
        self._templateUseCase = TemplateUseCase(jangdanRepository: self._jangdanDataSource)
        self._tempoUseCase = TempoUseCase(jangdanRepository: self._jangdanDataSource)
        self._metronomeOnOffUseCase = MetronomeOnOffUseCase(jangdanRepository: self._jangdanDataSource, soundManager: _soundManager)
        self._accentUseCase = AccentUseCase(jangdanRepository: self._jangdanDataSource)
        self._tapTapUseCase = TapTapUseCase(tempoUseCase: self._tempoUseCase)
        
        self._metronomeViewModel = MetronomeViewModel()
    }
    
    // ViewModel
    private var _metronomeViewModel: MetronomeViewModel
    var metronomeViewModel: MetronomeViewModel {
        self._metronomeViewModel
    }
    
    // UseCase Implements
    private var _templateUseCase: TemplateUseCase
    private var _tempoUseCase: TempoUseCase
    private var _metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var _accentUseCase: AccentUseCase
    private var _tapTapUseCase: TapTapUseCase
    
    private var _jangdanDataSource: JangdanDataSource
    private var _soundManager: SoundManager
    
    
    func registerJangdanRepository() -> JangdanRepository {
        return JangdanDataSource()
    }
    
    func registerSoundManager() -> SoundManager {
        return SoundManager()!
    }
    
    func registerTemplateUseCase(jangdanRepository: JangdanRepository) -> TemplateUseCase {
        return TemplateUseCase(jangdanRepository: jangdanRepository)
    }
    
    func registerTempoUseCase(jangdanRepository: JangdanRepository) -> TempoUseCase {
        return TempoUseCase(jangdanRepository: jangdanRepository)
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
