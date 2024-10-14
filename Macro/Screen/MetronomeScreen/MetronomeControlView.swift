//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct MetronomeControlView: View {
    @Binding var isPlaying: Bool
    @State private var bpmNum: Int = 90
    
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Text("빠르기(BPM)")
                    .font(.Callout_R)
                    .foregroundStyle(.textTertiary)
                    .padding(.bottom, 18)
                
                HStack(spacing: 16) {
                    Button(action: {
                        bpmNum -= 1
                    }, label: {
                        Circle()
                            .frame(width: 56)
                            .foregroundStyle(.buttonBPMControl)
                            .overlay {
                                Image(systemName: "minus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                    })
                    
                    Text("\(bpmNum)")
                        .font(.custom("Pretendard-Medium", size: 64))
                        .foregroundStyle(.textSecondary)
                        .frame(width: 120, height: 60)
                    
                    Button(action: {
                        bpmNum += 1
                    }, label: {
                        Circle()
                            .frame(width: 56)
                            .foregroundStyle(.buttonBPMControl)
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.textButtonSecondary)
                            }
                    })
                }
                
                Spacer()
                
                Button(action: {
                    isPlaying.toggle()
                }, label: {
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: 337, height: 80)
                        .foregroundStyle(.buttonPrimary)
                        .overlay {
                            Text(isPlaying ? "시작" : "멈춤")
                                .font(.LargeTitle_R)
                                .foregroundStyle(.textButtonPrimary)
                        }
                })
            }
            
            Spacer()
        }
        .padding(.vertical, 24)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 24, bottomTrailingRadius: 24, topTrailingRadius: 12)
                .fill(Color.cardBackground)
        }
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    MetronomeControlView()
//}
