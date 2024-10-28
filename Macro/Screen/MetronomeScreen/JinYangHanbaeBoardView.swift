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
        Grid(horizontalSpacing: 0) {
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
                            tabBakBarEvent(daebakIndex, sobak)
                        }
                        .gridCellColumns(6)
                        
                        if daebakIndex < 6 {
                            VStack {
                                Rectangle()
                                    .frame(width: 1, height: 12)
                                    .foregroundStyle(.bakbardivider)
                                    .offset(y: -16)
                                
                                Spacer()
                                
                                Rectangle()
                                    .frame(width: 1, height: 12)
                                    .foregroundStyle(.bakbardivider)
                                    .offset(y: 16)
                            }
                            .frame(width: 4)
                        }
                    }
                }
            }
        }
        .onAppear {
            print("진양장단 : \(jangdan)")
            print("대박카운트 : \(currentDaebak)")
        }
        .padding(.vertical, 16)
    }
}

extension JinYangHanbaeBoardView {
    private func calculateActiveIndex(daebakIndex: Int, currentIndex: Int) -> Int? {
        var beforeCurrentDaebakCount = 0
        for i in 0..<daebakIndex {
            beforeCurrentDaebakCount += jangdan[i].count
        }
        if beforeCurrentDaebakCount..<beforeCurrentDaebakCount + jangdan[daebakIndex].count ~= currentIndex {
            return currentIndex - beforeCurrentDaebakCount
        }
        return nil
    }
}
//
//#Preview {
//    JinYangHanbaeBoardView()
//}
