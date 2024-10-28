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
    var currentDaebak: Int
    var currentSobak: Int
    var tabBakBarEvent: (Int, Int) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 0) {
            ForEach(0..<(currentDaebak / 6), id: \.self) { rowIndex in // 4줄 아래로 쌓임
                GridRow {
                    ForEach(jangdan.indices, id: \.self) { daebakIndex in
                        
                        BakBarSetView(
                            accents: jangdan[rowIndex + daebakIndex],
                            daebakIndex: rowIndex + daebakIndex,
                            isDaebakOnly: !isSobakOn,
                            isPlaying: isPlaying,
                            activeIndex: currentDaebak == rowIndex + daebakIndex ? currentSobak : nil
                        ) { sobak in
                            tabBakBarEvent(daebakIndex, sobak)
                        }
                        .gridCellColumns(6)
                        
                        if daebakIndex < jangdan.count - 1 {
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
