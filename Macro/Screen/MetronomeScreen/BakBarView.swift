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
    var isPlaying: Bool
    var isActive: Bool
    var bakNumber: Int?
    var updateAccent: (Accent) -> Void
    
    @State private var startLocation: CGPoint? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(isPlaying && isActive ? .orange.opacity(0.5) : .frame)
                    Rectangle()
                        .frame(height: CGFloat((geo.size.height / 3) * Double(accentHeight)))
                        .foregroundStyle(isActive
                                         ? LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .top, endPoint: .bottom)
                                         : LinearGradient(colors: [.bakBarInactive], startPoint: .top, endPoint: .bottom))
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
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if startLocation == nil {
                            startLocation = gesture.location
                        }
                        
                        let limit = Int(geo.size.height / 3)
                        let diff = Int(gesture.location.y - startLocation!.y) / limit
                        if abs(diff) > 0 {
                            var newGrade = self.accent.rawValue + diff
                            if newGrade > 3 {
                                newGrade = 3
                            } else if newGrade < 0 {
                                newGrade = 0
                            }
                            updateAccent(Accent(rawValue: newGrade) ?? .none)
                            startLocation = nil
                        }
                    }
            )
            .onTapGesture {
                updateAccent(self.accent.nextAccent())
            }
        }
    }
}

#Preview {
    BakBarView(accent: .medium, isPlaying: false, isActive: true, bakNumber: 3) {_ in }
}
