//
//  TempMainView.swift
//  Macro
//
//  Created by Yunki on 10/9/24.
//

import SwiftUI
import Combine

struct TempMainView: View {
    @State var viewModel: TempMainViewModel = .init()
    @State private var sobakOnOff: Bool = false
    private func heightCalc(_ accent: Accent) -> CGFloat {
        switch accent {
        case .none:
            return 0
        case .weak:
            return 50
        case .medium:
            return 100
        case .strong:
            return 150
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                ForEach(0..<viewModel.state.jangdanAccents.count * viewModel.state.jangdanAccents[0].count, id: \.self) { index in
                    let daebak = index / viewModel.state.jangdanAccents[0].count // 3
                    let sobak = index % viewModel.state.jangdanAccents[0].count // 3
                    
                    Button {
                        self.viewModel.effect(action: .changeAccent(daebak: daebak, sobak: sobak))
                    } label: {
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(index == viewModel.state.currentIndex ? Color.red : Color.blue)
                                .frame(width: 20, height: heightCalc(viewModel.state.jangdanAccents[daebak][sobak]))
                        }
                        .frame(width: 20, height: 150)
                    }
                }
            }
            .padding()
            
            Button(viewModel.state.isPlaying ? "Stop" : "Play") {
                viewModel.effect(action: .playButton)
            }
            .padding()
            
            HStack {
                Button("-") {
                    viewModel.effect(action: .decreaseBpm)
                }
                Text("\(viewModel.state.bpm)")
                Button("+") {
                    viewModel.effect(action: .increaseBpm)
                }
            }
            .padding()
            
            Toggle(isOn: $sobakOnOff) {
                Text("소박 보기")
            }
            .onChange(of: sobakOnOff) {
                self.viewModel.effect(action: .changeSobakOnOff)
            }
            .padding()
        }
    }
}

@Observable
class TempMainViewModel {
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    private var accentUseCase : AccentUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    private var jangdanUISubscriber: AnyCancellable?
    
    init() {
        let initTemplateUseCase: TemplateUseCase = .init()
        let initSoundManager: SoundManager? = .init()
        
        self.templateUseCase = initTemplateUseCase
        self.metronomeOnOffUseCase = .init(templateUseCase: initTemplateUseCase, soundManager: initSoundManager!)
        self.tempoUseCase = .init(templateUseCase: initTemplateUseCase)
        self.accentUseCase = .init(templateUseCase: initTemplateUseCase)
        
        self.jangdanUISubscriber = templateUseCase.jangdanUIPublisher.sink { [weak self] jangdanUI in
            guard let self else { return }
            self._state.jangdanAccents = jangdanUI
        }
        self.jangdanUISubscriber?.store(in: &self.cancelBag)
        
        self.templateUseCase.setJangdan(name: "자진모리")
    }
    
    struct State {
        var isPlaying: Bool = false
        var currentIndex: Int = -1
        var bpm: Int = 60
        var jangdanAccents: [[Accent]] = [
            [.strong, .weak, .weak],
            [.strong, .weak, .weak],
            [.strong, .weak, .weak],
            [.strong, .weak, .weak]
        ]
        var sobakOnOff: Bool = false
    }
    
    private var _state: State = .init()
    var state: State { return _state }
    
    enum Action {
        case playButton // Play / Stop Button
        case decreaseBpm // - button
        case increaseBpm // + button
        case changeAccent(daebak: Int, sobak: Int)
        case changeSobakOnOff
    }
    
    func effect(action: Action) {
        switch action {
        case .playButton:
            self._state.currentIndex = -1
            self._state.isPlaying.toggle()
            
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.play {
                    self._state.currentIndex += 1
                    self._state.currentIndex %= self.templateUseCase.currentJangdanBakCount
                }
            } else {
                self.metronomeOnOffUseCase.stop()
            }
            
        case .decreaseBpm:
            self._state.bpm -= 10
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm)
            
        case .increaseBpm:
            self._state.bpm += 10
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm)
            
        case let .changeAccent(daebak, sobak):
            self.accentUseCase.moveNextAccent(daebakIndex: daebak, sobakIndex: sobak)
        case .changeSobakOnOff:
            self._state.sobakOnOff.toggle()
            self.templateUseCase.changeSobakOnOff()
        }
    }
}

#Preview {
    TempMainView()
}
