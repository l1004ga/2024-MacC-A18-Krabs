//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI
import Combine

struct MetronomeControlView: View {
    
    @State var viewModel: MetronomeViewModel
    @State var controlViewModel = DIContainer.shared.controlViewModel
    private let threshold: CGFloat = 10 // 드래그 시 숫자변동 빠르기 조절 위한 변수
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 위에 드래그 제스쳐 되어야 하는 영역
                VStack(spacing: 0) {
                    if !self.controlViewModel.isTapping {
                        Text("빠르기(BPM)")
                            .font(.Callout_R)
                            .foregroundStyle(.textTertiary)
                            .padding(.vertical, 5)
                    } else {
                        Text("원하는 빠르기로 계속 탭해주세요")
                            .font(.Body_SB)
                            .foregroundStyle(.textDefault)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .background(Color.backgroundDefault)
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 16){
                        Circle()
                            .fill(controlViewModel.isMinusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                            .frame(width: 56)
                            .overlay {
                                Image(systemName: "minus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                            .onTapGesture {
                                tapOnceAction(isIncreasing: false)
                            }
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                tapTwiceAction(isIncreasing: false, isPressing: isPressing)
                            }, perform: {})
                        
                        Text("\(controlViewModel.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 64))
                            .foregroundStyle(self.controlViewModel.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 120, height: 60)
                            .padding(8)
                            .background(self.controlViewModel.isTapping ? .backgroundDefault : .clear)
                            .cornerRadius(16)
                        
                        Circle()
                            .fill(controlViewModel.isPlusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                            .frame(width: 56)
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                            .onTapGesture {
                                tapOnceAction(isIncreasing: true)
                            }
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                tapTwiceAction(isIncreasing: true, isPressing: isPressing)
                            }, perform: {})
                    } .padding(.top, 25)
                    
                    Spacer()
                }
                .padding(.horizontal, 40.5)
                .padding(.top, 32)
                .frame(maxWidth: .infinity)
                .background(.backgroundCard)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragAction(gesture: gesture)
                        }
                        .onEnded { _ in
                            dragEnded()
                        }
                )
                
                // 아래 시작, 탭 버튼
                HStack(spacing: 16) {
                    Text(self.viewModel.state.isPlaying ? "멈춤" : "시작")
                        .font(.custom("Pretendard-Medium", fixedSize: 34))
                        .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonEmphasis)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(self.viewModel.state.isPlaying ? .buttonPlayStop : .buttonPlayStart)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.viewModel.effect(action: .changeIsPlaying)
                        }
                    
                    Text(self.controlViewModel.isTapping ? "탭" : "빠르기\n찾기")
                        .font(self.controlViewModel.isTapping ? .custom("Pretendard-Regular", size: 28) : .custom("Pretendard-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(self.controlViewModel.isTapping ? .textButtonEmphasis : .textButtonPrimary)
                        .frame(width: 120, height: 80)
                        .background(self.controlViewModel.isTapping ? .buttonActive : .buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.controlViewModel.effect(action: .estimateBpm)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 24)
                .background(.backgroundCard)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24))
            }
        }
        .padding(.horizontal, 16)
    }
    
    func roundedBpm(currentBpm: Int) -> Int {
        
        return currentBpm - (currentBpm % 10)
    }
    
    private func startTimer(isIncreasing: Bool) {
        controlViewModel.speed = 0.5
        stopTimer()
        controlViewModel.timerCancellable = Timer.publish(every: controlViewModel.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    let newBpm = roundedBpm(currentBpm: controlViewModel.bpm)
                    self.controlViewModel.effect(action: .increaseLongBpm(roundedBpm: newBpm))
                    controlViewModel.speed = max(0.08, controlViewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    let newBpm = roundedBpm(currentBpm: controlViewModel.bpm) + 10
                    self.controlViewModel.effect(action: .decreaseLongBpm(roundedBpm: newBpm))
                    controlViewModel.speed = max(0.08, controlViewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
        
    }
    
    private func restartTimer(isIncreasing: Bool) {
        stopTimer()
        controlViewModel.timerCancellable = Timer.publish(every: controlViewModel.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    self.controlViewModel.effect(action: .increaseLongBpm(roundedBpm: roundedBpm(currentBpm: controlViewModel.bpm)))
                    controlViewModel.speed = max(0.08, controlViewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    self.controlViewModel.effect(action: .decreaseLongBpm(roundedBpm: roundedBpm(currentBpm: controlViewModel.bpm)))
                    controlViewModel.speed = max(0.08, controlViewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
    }
    
    private func stopTimer() {
        controlViewModel.timerCancellable?.cancel()
        controlViewModel.timerCancellable = nil
    }
    
    // 증감 active 체크
    private func toggleActiveState(isIncreasing: Bool, isActive: Bool) {
        if isIncreasing {
            controlViewModel.isPlusActive = isActive
        } else {
            controlViewModel.isMinusActive = isActive
        }
    }
    
    // 단일탭 액션
    private func tapOnceAction(isIncreasing: Bool) {
            self.controlViewModel.effect(action: isIncreasing ? .increaseShortBpm : .decreaseShortBpm)
        
        
        withAnimation {
            toggleActiveState(isIncreasing: isIncreasing, isActive: true)
        }
        
        // 클릭 후 다시 비활성화 색상
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                toggleActiveState(isIncreasing: isIncreasing, isActive: false)
            }
        }
    }
    
    // 롱탭 액션
    private func tapTwiceAction(isIncreasing: Bool, isPressing: Bool) {
        withAnimation {
            toggleActiveState(isIncreasing: isIncreasing, isActive: isPressing)
        }
        
        if isPressing {
            startTimer(isIncreasing: isIncreasing)
        } else {
            stopTimer()
        }
    }
    
    // 드래그 제스쳐 액션
    private func dragAction(gesture: DragGesture.Value) {
        // 현재 위치값을 기준으로 증감 측정
        let translationDifference = gesture.translation.width - controlViewModel.previousTranslation
        
        if abs(translationDifference) > threshold {   // 음수값도 있기 때문에 절댓값 사용
            if translationDifference > 0 {
                self.controlViewModel.effect(action: .increaseShortBpm)
                controlViewModel.isPlusActive = true
                controlViewModel.isMinusActive = false
            } else if translationDifference < 0 {
                self.controlViewModel.effect(action: .decreaseShortBpm)
                controlViewModel.isMinusActive = true
                controlViewModel.isPlusActive = false
            }
            
            controlViewModel.previousTranslation = gesture.translation.width
        }
    }
    
    // 드래그 제스쳐 끝났을 때
    private func dragEnded() {
        controlViewModel.isMinusActive = false
        controlViewModel.isPlusActive = false
        controlViewModel.previousTranslation = 0
    }
}

//#Preview {
//    MetronomeControlView()
//}
