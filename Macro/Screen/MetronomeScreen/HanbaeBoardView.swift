//
//  HanbaeBoardView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct HanbaeBoardView: View {
    var jangdan: [[[Accent]]]
    var isSobakOn: Bool
    var isPlaying: Bool
    var currentRow: Int
    var currentDaebak: Int
    var currentSobak: Int
    var tabBakBarEvent: (Int, Int, Int, Accent) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 8) {
            ForEach(jangdan.indices, id: \.self) { row in
                // 이전까지의 대박 갯수 누적합
                let prefixSum: Int = {
                    var sum = 0
                    for _ in 0..<row {
                        sum += jangdan[row].count
                    }
                    return sum
                }()
                
                GridRow {
                    ForEach(jangdan[row].indices, id: \.self) { daebakIndex in
                        BakBarSetView(
                            accents: jangdan[row][daebakIndex],
                            daebakIndex: daebakIndex + prefixSum,
                            isDaebakOnly: !isSobakOn,
                            isPlaying: isPlaying,
                            activeIndex: currentRow == row && currentDaebak == daebakIndex ? currentSobak : nil
                        ) { sobakIndex, newAccent in
                            tabBakBarEvent(row, daebakIndex, sobakIndex, newAccent)
                        }
                        .gridCellColumns(jangdan[row][daebakIndex].count)
                    }
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    HanbaeBoardView(
        jangdan: [[[.strong, .weak],
                   [.weak, .medium, .medium],
                   [.weak, .weak],
                   [.weak, .weak, .weak]]], isSobakOn: true, isPlaying: true, currentRow: 0, currentDaebak: 1, currentSobak: 2) { _, _, _, _ in }
}
