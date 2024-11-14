//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct MetronomeControlView: View {
    
    @State var viewModel: MetronomeViewModel
    @State private var isDecreasing: Bool = false
    @State private var isIncreasing: Bool = false
    @State private var delay: Double = 0.1
    @State private var roundedDelay: Double = 0.5  // 10 단위로 반올림 되어질 애들의 딜레이 위한 변수
    @State private var isMinusActive: Bool = false
    @State private var isPlusActive: Bool = false
    @State private var previousTranslation: CGFloat = .zero  // 드래그 움직임
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
                            .fill(isMinusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                            .frame(width: 56)
                            .overlay {
                                Image(systemName: "minus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                            .onTapGesture {
                                if !isDecreasing {
                                    self.viewModel.effect(action: .decreaseShortBpm)
                                }
                                
                                withAnimation {
                                    isMinusActive = true
                                }
                                
                                // 클릭 후 다시 비활성화 색상
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isMinusActive = false
                                    }
                                }
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.1)
                                    .onChanged { _ in
                                        withAnimation {
                                            isMinusActive = true
                                        }
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + roundedDelay) {
                                            self.viewModel.effect(action: .roundBpm(currentBpm: downBpm(currentBpm: viewModel.state.bpm)))
                                            
                                            isDecreasing = true
                                            delay = 0.5
                                            startRepeatingDecreaseAction()
                                        }
                                    }
                            )
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                withAnimation {
                                    isMinusActive = isPressing
                                }
                                
                                if !isPressing {
                                    isDecreasing = false
                                }
                            }, perform: {})
                        
                        Text("\(viewModel.state.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 64))
                            .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 120, height: 60)
                            .padding(8)
                            .background(self.viewModel.state.isTapping ? .backgroundDefault : .clear)
                            .cornerRadius(16)
                        
                        Circle()
                            .fill(isPlusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                            .frame(width: 56)
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                            .onTapGesture {
                                if !isIncreasing {
                                    self.viewModel.effect(action: .increaseShortBpm)
                                }
                                
                                withAnimation {
                                    isPlusActive = true
                                }
                                
                                // 클릭 후 다시 비활성화 색상
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isPlusActive = false
                                    }
                                }
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.1)
                                    .onChanged { _ in
                                        withAnimation {
                                            isPlusActive = true
                                        }
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + roundedDelay) {
                                            self.viewModel.effect(action: .roundBpm(currentBpm: upBpm(currentBpm: viewModel.state.bpm)))
                                            
                                            isIncreasing = true
                                            delay = 0.5
                                            startRepeatingIncreaseAction()
                                        }
                                    }
                            )
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                withAnimation {
                                    isPlusActive = isPressing
                                }
                                
                                if !isPressing {
                                    isIncreasing = false
                                }
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
                            
                            // 현재 위치값을 기준으로 증감 측정
                            let translationDifference = gesture.translation.width - previousTranslation
                            
                            if abs(translationDifference) > threshold {   // 음수값도 있기 때문에 절댓값 사용
                                if translationDifference > 0 {
                                    self.viewModel.effect(action: .increaseShortBpm)
                                    isPlusActive = true
                                    isMinusActive = false
                                } else if translationDifference < 0 {
                                    self.viewModel.effect(action: .decreaseShortBpm)
                                    isMinusActive = true
                                    isPlusActive = false
                                }
                                
                                previousTranslation = gesture.translation.width
                            }
                            
                        }
                        .onEnded { _ in
                            if isMinusActive {
                                isMinusActive = false
                            } else if isPlusActive {
                                isPlusActive = false
                            }
                            previousTranslation = 0
                        }
                )
                
                // 아래 시작, 탭 버튼
                HStack(spacing: 16) {
                    Text(self.viewModel.state.isPlaying ? "멈춤" : "시작")
                        .font(.custom("Pretendard-Medium", fixedSize: 34))
                        .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonPlayStart)
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
    
    // 롱탭 시 감소 반복 도와줌
    func startRepeatingDecreaseAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isDecreasing {
                self.viewModel.effect(action: .decreaseLongBpm)
                delay = max(0.08, delay * 0.5)
                startRepeatingDecreaseAction()
            }
        }
    }
    
    // 롱탭 시 증가 반복 도와줌
    func startRepeatingIncreaseAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isIncreasing {
                self.viewModel.effect(action: .increaseLongBpm)
                delay = max(0.08, delay * 0.5)
                startRepeatingIncreaseAction()
            }
        }
    }
    
    func downBpm(currentBpm: Int) -> Int {
        
        return currentBpm - (currentBpm % 10)
    }
    
    func upBpm(currentBpm: Int) -> Int {
        
        return currentBpm + (10 - currentBpm % 10)
    }
}

//#Preview {
//    MetronomeControlView()
//}
