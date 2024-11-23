//
//  SobakSegmentView.swift
//  Macro
//
//  Created by leejina on 11/19/24.
//

import SwiftUI

struct SobakSegmentsView: View {
    var sobakSegmentCount: Int
    var currentSobak: Int
    var isPlaying: Bool
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<sobakSegmentCount, id: \.self) { index in
                Rectangle()
                    .foregroundStyle(isPlaying
                                     ? self.currentSobak == index ? index == 0 ? .sobakSegmentDaebak : .sobakSegmentSobak : .frame
                                     : .frame)
            }
        }
        .background(isPlaying ? .bakBarBorder : .bakBarLine)
        .frame(height: 20)
        .overlay {
            if isPlaying {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.bakBarBorder, lineWidth: 2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    SobakSegmentsView(sobakSegmentCount: 3, currentSobak: 2, isPlaying: true)
}
