//
//  TempMainView.swift
//  Macro
//
//  Created by Yunki on 10/9/24.
//

import SwiftUI

struct TempMainView: View {
    @State var viewModel: TempMainViewModel = .init()
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<12) { index in
                        Rectangle()
                            .fill(index == viewModel.state.currentIndex ? Color.red : Color.blue)
                            .frame(width: 20, height: 50)
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
        }
    }
}

@Observable
class TempMainViewModel {
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    
    init() {
        let initTemplateUseCase: TemplateUseCase = .init()
        let initSoundManager: SoundManager? = .init()
        
        initTemplateUseCase.setJangdan(name: "자진모리")
        
        self.templateUseCase = initTemplateUseCase
        self.metronomeOnOffUseCase = .init(templateUseCase: initTemplateUseCase, soundManager: initSoundManager!)
        self.tempoUseCase = .init(templateUseCase: initTemplateUseCase)
    }
    
    struct State {
        var isPlaying: Bool = false
        var currentIndex: Int = -1
        var bpm: Int = 60
    }
    
    private var _state: State = .init()
    var state: State { return _state }
    
    enum Action {
        case playButton // Play / Stop Button
        case decreaseBpm // - button
        case increaseBpm // + button
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
            self._state.bpm -= 1
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm)
            
        case .increaseBpm:
            self._state.bpm += 1
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm)
        }
    }
}

#Preview {
    TempMainView()
}
