//
//  DaebakPendulumView.swift
//  Macro
//
//  Created by leejina on 10/22/24.
//

import SwiftUI

struct DaebakPendulumView: View {
    var trigger: Bool

    var body: some View {
        ZStack(alignment: trigger ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 100)
                .foregroundStyle(.frame)
                .frame(height: 16)
            Circle()
                .frame(height: 16)
                .foregroundStyle(.bub)
        }
    }
}

#Preview {
    DaebakPendulumView(trigger: false)
}
