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
    var tabBakBarEvent: (Int, Int, Int) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 8) {
            ForEach(jangdan.indices, id: \.self) { row in
                GridRow {
                    ForEach(jangdan[row].indices, id: \.self) { daebakIndex in
                        
                        BakBarSetView(
                            accents: jangdan[row][daebakIndex],
                            daebakIndex: daebakIndex,
                            isDaebakOnly: !isSobakOn,
                            isPlaying: isPlaying,
                            activeIndex: currentRow == row && currentDaebak == daebakIndex ? currentSobak : nil
                        ) { sobak in
                            tabBakBarEvent(row, daebakIndex, sobak)
                        }
                        .gridCellColumns(jangdan[row][daebakIndex].count)
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    HanbaeBoardView(
        jangdan: [[[.strong, .weak],
                  [.weak, .medium, .medium],
                  [.weak, .weak],
                   [.weak, .weak, .weak]]], isSobakOn: true, isPlaying: true, currentRow: 0, currentDaebak: 1, currentSobak: 2) { _, _, _ in }
}
