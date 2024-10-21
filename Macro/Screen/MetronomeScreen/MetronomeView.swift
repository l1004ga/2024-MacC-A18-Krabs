//
//  MetronomeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI
import Combine

struct MetronomeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var viewModel: MetronomeViewModel
    
    @State private var jangdan: Jangdan
    @State private var isSheetPresented: Bool = false
    @State private var isSobakOn: Bool = false
    @State private var isPendulumOn: Bool = false
    
    init(jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = MetronomeViewModel()
        self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
        self.isSobakOn = self.viewModel.state.isSobakOn
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            DaebakPendulumView(trigger: self.isPendulumOn)
                .padding(.horizontal, 8)
                .padding(.top, 24)
                .padding(.bottom, 16)
            
            HanbaeBoardView(
                jangdan: viewModel.state.jangdanAccent,
                isSobakOn: viewModel.state.isSobakOn,
                isPlaying: viewModel.state.isPlaying,
                currentIndex: viewModel.state.currentIndex // 여기서는 전체 박의 개수가 반복되어서 들어감
            ) { daebak, sobak in
                viewModel.effect(action: .changeAccent(daebak: daebak, sobak: sobak))
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 26)
            
            SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdan)
                .padding(.bottom, 16)
            
            
            MetronomeControlView(viewModel: viewModel)
            
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
        .onChange(of: self.viewModel.state.pendulumTrigger) { newValue in
            withAnimation(.snappy(duration: 60.0 / Double(self.viewModel.state.bpm))) {
                self.isPendulumOn = newValue
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.effect(action: .stopMetronome)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // 장단 선택 List title
            ToolbarItem(placement: .principal) {
                Button(action: {
                    isSheetPresented.toggle()
                }) {
                    HStack(spacing: 0) {
                        Text("\(jangdan.name)")
                            .font(.Body_R)
                            .foregroundStyle(.textSecondary)
                            .padding(.trailing, 6)
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.textSecondary)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .toolbarBackground(.navigationbarbackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSheetPresented) {
            JangdanSelectSheetView(jangdan: $jangdan, isSheetPresented: $isSheetPresented, sendJangdan: {
                self.viewModel.effect(action: .stopMetronome)
                self.isSobakOn = false // view의 소박보기 false
                self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
            })
            .presentationDragIndicator(.visible)
        }
    }
}

@Observable
class MetronomeViewModel {
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    private var accentUseCase: AccentUseCase
    
    private var jangdanUISubscriber: AnyCancellable?
    private var bpmSubscriber: AnyCancellable?
    private var cancelBag: Set<AnyCancellable> = []
    
    init() {
        let initTemplateUseCase = TemplateUseCase(jangdanRepository: JangdanRepository())
        self.templateUseCase = initTemplateUseCase
        let initSoundManager: SoundManager? = .init()
        // TODO: SoundManager 에러처리하고 언래핑 풀어주기~
        self.metronomeOnOffUseCase = MetronomeOnOffUseCase(templateUseCase: initTemplateUseCase, soundManager: initSoundManager!)
        self.tempoUseCase = TempoUseCase(templateUseCase: initTemplateUseCase)
        self.accentUseCase = AccentUseCase(templateUseCase: initTemplateUseCase)
        self.jangdanUISubscriber = self.templateUseCase.jangdanPublisher.sink { [weak self] jangdanUI in
            guard let self else { return }
            self._state.jangdanAccent = jangdanUI
        }
        self.jangdanUISubscriber?.store(in: &self.cancelBag)
        self.bpmSubscriber = self.templateUseCase.bpmUIPublisher.sink { [weak self] bpm in
            guard let self else { return }
            self._state.bpm = bpm
        }
        self.bpmSubscriber?.store(in: &self.cancelBag)
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
    struct State {
        var currentJangdan: Jangdan?
        var jangdanAccent: [[Accent]] = []
        var bakCount: Int = 0
        var daebakCount: Int = 0
        var isSobakOn: Bool = false
        var isPlaying: Bool = false
        var currentIndex: Int = 0
        var bpm: Int = 60
        var pendulumTrigger: Bool = false
    }
    
    enum Action {
        case selectJangdan(jangdan: Jangdan)
        case changeSobakOnOff
        case changeIsPlaying
        case decreaseBpm // - button
        case increaseBpm // + button
        case changeAccent(daebak: Int, sobak: Int)
        case stopMetronome
    }
    
    func effect(action: Action) {
        switch action {
        case let .selectJangdan(jangdan):
            self._state.currentJangdan = jangdan
            self.templateUseCase.setJangdan(jangdan: jangdan)
            self._state.bakCount = self.templateUseCase.currentJangdanBakCount
            self._state.daebakCount = self.templateUseCase.currentJangdanDaebakCount
        case .changeSobakOnOff:
            self._state.isSobakOn.toggle()
            self.metronomeOnOffUseCase.changeSobak()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.stop()
                self._state.currentIndex = 0
                self._state.pendulumTrigger = false
                self.metronomeOnOffUseCase.play {
                    self._state.currentIndex = (self._state.currentIndex + 1) % self._state.bakCount
                    let sobakCount = self._state.bakCount / self._state.daebakCount
                    if self._state.currentIndex % sobakCount == 0 {
                        self._state.pendulumTrigger.toggle()
                    }
                }
            }
        case .changeIsPlaying:
            self._state.currentIndex = 0
            self._state.isPlaying.toggle()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.play {
                    self._state.currentIndex = (self._state.currentIndex + 1 ) % self._state.bakCount
                    let sobakCount = self._state.bakCount / self._state.daebakCount
                    if self._state.currentIndex % sobakCount == 0 {
                        self._state.pendulumTrigger.toggle()
                    }
                }
            } else {
                self.metronomeOnOffUseCase.stop()
                self._state.pendulumTrigger = false
            }
        case .decreaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm - 1)
            
        case .increaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm + 1)
            
        case let .changeAccent(daebak, sobak):
            self.accentUseCase.moveNextAccent(daebakIndex: daebak, sobakIndex: sobak)
        case .stopMetronome: // 시트 변경 시 소리 중지를 위해 사용함
            self._state.isPlaying = false
            self.metronomeOnOffUseCase.stop()
            self._state.pendulumTrigger = false
        }
    }
}
