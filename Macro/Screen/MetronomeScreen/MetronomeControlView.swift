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
    @State private var delay: Double = 0.5
    
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 24, bottomTrailingRadius: 24, topTrailingRadius: 12)
                .fill(Color.backgroundCard)
            
            VStack {
                VStack(spacing: 18) {
                    Text("빠르기(BPM)")
                        .font(.Callout_R)
                        .foregroundStyle(.textTertiary)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            self.viewModel.effect(action: .decreaseShortBpm)
                        }, label: {
                            Circle()
                                .frame(width: 56)
                                .foregroundStyle(.buttonBPMControlDefault)
                                .overlay {
                                    Image(systemName: "minus")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.textButtonSecondary)
                                }
                        })
                        .simultaneousGesture(
                             LongPressGesture(minimumDuration: 0.5)
                                 .onEnded { _ in
                                     isDecreasing = true
                                     delay = 0.5
                                     startRepeatingDecreaseAction()
                                 }
                         )
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                            if !isPressing { isDecreasing = false }
                        }, perform: {})
                        
                        Text("\(viewModel.state.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 64))
                            .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 120)
                        
                        Button(action: {
                            self.viewModel.effect(action: .increaseShortBpm)
                        }, label: {
                            Circle()
                                .frame(width: 56)
                                .foregroundStyle(.buttonBPMControlDefault)
                                .overlay {
                                    Image(systemName: "plus")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.textButtonSecondary)
                                }
                        })
                        .simultaneousGesture(
                             LongPressGesture(minimumDuration: 0.5)
                                 .onEnded { _ in
                                     isIncreasing = true
                                     delay = 0.5
                                     startRepeatingIncreaseAction()
                                 }
                         )
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                            if !isPressing { isIncreasing = false }
                        }, perform: {})
                    }
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundStyle(self.viewModel.state.isPlaying ? .buttonPlayStop : .buttonPlayStart)
                        .overlay {
                            Text(self.viewModel.state.isPlaying ? "멈춤" : "시작")
                                .font(.LargeTitle_R)
                                .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonPlayStart)
                        }
                        .onTapGesture {
                            self.viewModel.effect(action: .changeIsPlaying)
                        }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(viewModel.state.isTapping ? .buttonToggleOn : .buttonPrimary)
                        
                        if self.viewModel.state.isTapping {
                            Text("탭")
                                .font(.custom("Pretendard-Regular", size: 28))
                                .foregroundStyle(.textButtonPrimary)
                        } else {
                            Text("빠르기\n찾기")
                                .font(.custom("Pretendard-Regular", size: 17))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.textButtonPrimary)
                        }
                    }
                    .frame(width: 120)
                    .onTapGesture {
                        self.viewModel.effect(action: .estimateBpm)
                    }
                }
                .frame(height: 80)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 12)
        }
        .frame(maxHeight: 265)
        .padding(.horizontal, 16)
    }
    
    func startRepeatingDecreaseAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isDecreasing {
                self.viewModel.effect(action: .decreaseLongBpm)
                delay = max(0.08, delay * 0.8)
                startRepeatingDecreaseAction()
            }
        }
    }
    
    func startRepeatingIncreaseAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isIncreasing {
                self.viewModel.effect(action: .increaseLongBpm)
                delay = max(0.08, delay * 0.8)
                startRepeatingIncreaseAction()
            }
        }
    }
}

//#Preview {
//    MetronomeControlView()
//}
