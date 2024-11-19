//
//  SobakSegmentView.swift
//  Macro
//
//  Created by leejina on 11/19/24.
//

import SwiftUI

struct SobakSegmentsView: View {
    var body: some View {
        HStack(spacing: 1) {
            Rectangle()
                .foregroundStyle(.sobakSegmentDaebak)
            Rectangle()
                .foregroundStyle(.frame)
        }
        .background(.bakBarBorder)
        .frame(height: 20)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.bakBarBorder, lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    SobakSegmentsView()
}

