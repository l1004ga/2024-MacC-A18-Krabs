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
        self._tapTapUseCase = TapTapImplement(tempoUseCase: self._tempoUseCase)
        
        self._metronomeViewModel = MetronomeViewModel(jangdanRepository: self._jangdanDataSource, templateUseCase: self._templateUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase, tempoUseCase: self._tempoUseCase, accentUseCase: self._accentUseCase, taptapUseCase: self._tapTapUseCase)
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
    private var _tapTapUseCase: TapTapImplement
    
    private var _jangdanDataSource: JangdanDataSource
    private var _soundManager: SoundManager
    
}
