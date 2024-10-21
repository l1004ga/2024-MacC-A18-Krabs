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
                .foregroundStyle(.bakbarsetframe)
                .frame(height: 16)
            Circle()
                .frame(height: 16)
            // TODO: Color 디자인 바꿔야 함
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    DaebakPendulumView(trigger: false)
}
