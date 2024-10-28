//
//  JinYangHanbaeBoardView.swift
//  Macro
//
//  Created by leejina on 10/28/24.
//

import SwiftUI

struct JinYangHanbaeBoardView: View {
    var jangdan: [[Accent]]
    var isSobakOn: Bool
    var isPlaying: Bool
    var currentDaebak: Int // 현재 실행중인 박을 확인하기 위함
    var currentSobak: Int
    var tabBakBarEvent: (Int, Int) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 10) {
            ForEach(0..<4, id: \.self) { rowIndex in // 4줄 아래로 쌓임
                GridRow {
                    ForEach(0..<6, id: \.self) { daebakIndex in
                        let newIndex = rowIndex * 6 + daebakIndex
                        BakBarSetView(
                            accents: jangdan[newIndex],
                            daebakIndex: newIndex,
                            isDaebakOnly: !isSobakOn,
                            isPlaying: isPlaying,
                            activeIndex: currentDaebak == newIndex ? currentSobak : nil
                        ) { sobak in
                            tabBakBarEvent(newIndex, sobak)
                        }
                        
                        if daebakIndex < 5 {
                            VStack {
                                Rectangle()
                                    .frame(width: 1, height: 1...3 ~= rowIndex ? 1 : 12)
                                    .foregroundStyle(.bakbardivider)
                                    .offset(y: -16)
                                    .opacity(1...3 ~= rowIndex ? 0 : 1)
                                
                                Spacer()
                                
                                Rectangle()
                                    .frame(width: 1, height: 0...2 ~= rowIndex ? 1 : 12)
                                    .foregroundStyle(.bakbardivider)
                                    .offset(y: 16)
                                    .opacity(0...2 ~= rowIndex ? 0 : 1)
                            }
                            .frame(width: 4)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
}

//
//#Preview {
//    JinYangHanbaeBoardView()
//}
