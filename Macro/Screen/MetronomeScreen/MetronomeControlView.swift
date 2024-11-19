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
    private let threshold: CGFloat = 10 // 드래그 시 숫자변동 빠르기 조절 위한 변수
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 위에 드래그 제스쳐 되어야 하는 영역
                VStack(spacing: 0) {
                    if !self.viewModel.state.isTapping {
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
                            .fill(viewModel.isMinusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
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
                        
                        Text("\(viewModel.state.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 64))
                            .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 120, height: 60)
                            .padding(8)
                            .background(self.viewModel.state.isTapping ? .backgroundDefault : .clear)
                            .cornerRadius(16)
                        
                        Circle()
                            .fill(viewModel.isPlusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
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
                    
                    Text(self.viewModel.state.isTapping ? "탭" : "빠르기\n찾기")
                        .font(self.viewModel.state.isTapping ? .custom("Pretendard-Regular", size: 28) : .custom("Pretendard-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(self.viewModel.state.isTapping ? .textButtonEmphasis : .textButtonPrimary)
                        .frame(width: 120, height: 80)
                        .background(self.viewModel.state.isTapping ? .buttonActive : .buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.viewModel.effect(action: .estimateBpm)
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
        viewModel.speed = 0.5
        stopTimer()
        viewModel.timerCancellable = Timer.publish(every: viewModel.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    let newBpm = roundedBpm(currentBpm: viewModel.state.bpm)
                    self.viewModel.effect(action: .increaseLongBpm(roundedBpm: newBpm))
                    viewModel.speed = max(0.08, viewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    let newBpm = roundedBpm(currentBpm: viewModel.state.bpm) + 10
                    self.viewModel.effect(action: .decreaseLongBpm(roundedBpm: newBpm))
                    viewModel.speed = max(0.08, viewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
        
    }
    
    private func restartTimer(isIncreasing: Bool) {
        stopTimer()
        viewModel.timerCancellable = Timer.publish(every: viewModel.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    self.viewModel.effect(action: .increaseLongBpm(roundedBpm: roundedBpm(currentBpm: viewModel.state.bpm)))
                    viewModel.speed = max(0.08, viewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    self.viewModel.effect(action: .decreaseLongBpm(roundedBpm: roundedBpm(currentBpm: viewModel.state.bpm)))
                    viewModel.speed = max(0.08, viewModel.speed * 0.5)
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
    }
    
    private func stopTimer() {
        viewModel.timerCancellable?.cancel()
        viewModel.timerCancellable = nil
    }
    
    // 증감 active 체크
    private func toggleActiveState(isIncreasing: Bool, isActive: Bool) {
        if isIncreasing {
            viewModel.isPlusActive = isActive
        } else {
            viewModel.isMinusActive = isActive
        }
    }
    
    // 단일탭 액션
    private func tapOnceAction(isIncreasing: Bool) {
        if !viewModel.isLongTapping {
            self.viewModel.effect(action: isIncreasing ? .increaseShortBpm : .decreaseShortBpm)
        }
        
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
        let translationDifference = gesture.translation.width - viewModel.previousTranslation
        
        if abs(translationDifference) > threshold {   // 음수값도 있기 때문에 절댓값 사용
            if translationDifference > 0 {
                self.viewModel.effect(action: .increaseShortBpm)
                viewModel.isPlusActive = true
                viewModel.isMinusActive = false
            } else if translationDifference < 0 {
                self.viewModel.effect(action: .decreaseShortBpm)
                viewModel.isMinusActive = true
                viewModel.isPlusActive = false
            }
            
            viewModel.previousTranslation = gesture.translation.width
        }
    }
    
    // 드래그 제스쳐 끝났을 때
    private func dragEnded() {
        viewModel.isMinusActive = false
        viewModel.isPlusActive = false
        viewModel.previousTranslation = 0
    }
}

//#Preview {
//    MetronomeControlView()
//}
