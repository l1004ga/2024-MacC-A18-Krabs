//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct MetronomeControlView: View {
    
    @State var viewModel: MetronomeViewModel
    
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
                            self.viewModel.effect(action: .decreaseBpm)
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
                        .buttonRepeatBehavior(.enabled)
                        
                        Text("\(viewModel.state.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 64))
                            .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 120)
                        
                        Button(action: {
                            self.viewModel.effect(action: .increaseBpm)
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
                        .buttonRepeatBehavior(.enabled)
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
}

//#Preview {
//    MetronomeControlView()
//}
