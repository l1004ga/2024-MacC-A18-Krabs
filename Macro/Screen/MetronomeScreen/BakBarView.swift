//
//  BakBarView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct BakBarView: View {
    var accent: Accent
    var accentHeight: Int {
        switch self.accent {
        case .strong:
            return 3
        case .medium:
            return 2
        case .weak:
            return 1
        case .none:
            return 0
        }
    }
    var isActive: Bool
    var bakNumber: Int?
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.frame)
                    Rectangle()
                        .frame(height: CGFloat((geo.size.height / 3) * Double(accentHeight)))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                                        startPoint: .top, endPoint: .bottom))

                }
                if let bakNumber {
                    Text("\(bakNumber)")
                        .font(.system(size: 32, weight: .semibold))
                        .padding(.top, 16)
                        .foregroundColor(
                            isActive
                            ? accent == .strong ? .bakBarNumberBlack : geo.size.height < 100 && accent == .medium ? .bakBarNumberBlack : .bakBarNumberWhite
                            : accent == .strong ? .bakBarNumberBlack : geo.size.height < 100 && accent == .medium ? .bakBarNumberBlack : .bakBarNumberGray
                        )
                }
                
            }
        }
    }
}

#Preview {
    BakBarView(accent: .medium, isActive: true, bakNumber: 3)
}
