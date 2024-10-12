//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct MetronomeControlView: View {
    @State private var isPlaying: Bool = false
    @State private var bpmNum: Int = 90
    
    // geometry 설정을 위한 변수
    @State var geoSize: CGSize = .zero
    
    var body: some View {
                VStack {
                    Text("빠르기(BPM)")
                        .font(.Callout_R)
                        .foregroundStyle(.textTertiary)
                        .padding(.bottom, geoSize.height * 0.021)
                    
                    HStack(spacing: geoSize.width * 0.041) {
                        Button(action: {
                            bpmNum -= 1
                        }, label: {
                            Circle()
                                .frame(width: geoSize.width * 0.142) // TODO: 확인 필요 반응형 할건지
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
                            .frame(width: geoSize.width * 0.31, height: geoSize.height * 0.07)
                        
                        Button(action: {
                            bpmNum += 1
                        }, label: {
                            Circle()
                                .frame(width: geoSize.width * 0.142) // TODO: 확인 필요 반응형 할건지
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
                            .frame(width: geoSize.width * 0.86, height: geoSize.height * 0.094)
                            .foregroundStyle(.buttonPrimary)
                            .overlay {
                                Text(isPlaying ? "시작" : "멈춤")
                                    .font(.LargeTitle_R)
                                    .foregroundStyle(.textButtonPrimary)
                            }
                    })
                }
                .padding(.vertical, geoSize.height * 0.028)
                .padding(.horizontal, geoSize.width * 0.031)
                .frame(width: geoSize.width * 0.92, height: geoSize.height * 0.31)
                .background {
                    UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 24, bottomTrailingRadius: 24, topTrailingRadius: 12)
                        .foregroundStyle(.cardBackground)
//                        .frame(width: geoSize.width * 0.92, height: geoSize.height * 0.31)
                }
    }
}

#Preview {
    MetronomeControlView()
}
