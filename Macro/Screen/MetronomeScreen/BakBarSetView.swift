//
//  BakBarSetView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct BakBarSetView: View {
    var accents: [Accent]
    var daebakIndex: Int
    var isDaebakOnly: Bool
    var isPlaying: Bool
    var activeIndex: Int?
    var tabBakBarEvent: (Int) -> Void
    
    var body: some View {
        if isDaebakOnly {
            BakBarView(accent: accents[0], isPlaying: isPlaying, isActive: !isPlaying || activeIndex != nil, bakNumber: daebakIndex + 1)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.green, lineWidth: 2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .onTapGesture {
                    tabBakBarEvent(0)
                }
        } else {
            HStack(spacing: 0) {
                ForEach(accents.indices, id: \.self) { index in
                    BakBarView(
                        accent: accents[index],
                        isPlaying: isPlaying,
                        isActive: !isPlaying || index == activeIndex,
                        bakNumber: index == 0 ? daebakIndex + 1 : nil
                    )
                    .overlay {
                        // 마지막 인덱스가 아닌 경우에만 테두리 추가
                        if index > 0 {
                            HStack {
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(.bakBarLine)
                                
                                Spacer()
                            }
                        }
                    }
                    .onTapGesture {
                        tabBakBarEvent(index)
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.green, lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

#Preview {
    BakBarSetView(accents: [.strong, .medium, .weak, .none], daebakIndex: 3, isDaebakOnly: false, isPlaying: true, activeIndex: nil) {_ in}
}
