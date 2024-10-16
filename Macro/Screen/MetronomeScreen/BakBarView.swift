//
//  BakBarView.swift
//  Macro
//
//  Created by jhon on 10/14/24.
//

import SwiftUI

struct BakBarView: View {
    // 외부에서 받을 값들: 바의 높이, 너비, 초기 강세
    @State var currentAccent: Accent // 외부에서 첫 강세 값을 받음
    var bakInt: Int = 1
    var barHeight: CGFloat
    var barWidth: CGFloat
    var barColor: Color // 외부에서 색상을 전달받음\
    var strongAccentIntColor: Color
    var elseAccentIntColor: Color
    var accent: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                // 배경 영역 (고정된 바 배경)
                Rectangle()
                    .fill(Color.bakBarSetFrame) // 배경 색상 설정
                    .frame(width: barWidth, height: barHeight) // 고정된 배경 바 크기
                
                // 바 (변경되는 길이)
                Rectangle()
                    .fill(barColor) // 바 색상
                    .frame(width: barWidth, height: barHeight * heightForAccent(currentAccent), alignment: .bottom) // 위로 줄어드는 바
            }
            .contentShape(Rectangle()) // 터치 영역을 전체로 설정
            .onTapGesture {
                cycleAccent() // 터치할 때 강세를 변경
                accent()
            }
            
            if bakInt != 0 { // 박 숫자를 표시하는지 여부
                if currentAccent != .strong {
                    Text("\(bakInt)")
                        .font(.system(size: 32, weight: .semibold))
                        .padding(.top, 16)
                        .foregroundColor(elseAccentIntColor)
                } else {
                    Text("\(bakInt)")
                        .font(.system(size: 32, weight: .semibold))
                        .padding(.top, 16)
                        .foregroundColor(strongAccentIntColor)
                }
            }
        }
    }
    
    // 터치할 때 강세를 순환시키는 함수
    private func cycleAccent() {
        switch currentAccent {
        case .strong:
            currentAccent = .medium
        case .medium:
            currentAccent = .weak
        case .weak:
            currentAccent = .none
        case .none:
            currentAccent = .strong
        }
    }
    
    // 강세에 따른 높이 비율을 반환하는 함수
    private func heightForAccent(_ accent: Accent) -> CGFloat {
        switch accent {
        case .strong:
            return 1.0
        case .medium:
            return 0.66
        case .weak:
            return 0.33
        case .none:
            return 0.0
        }
    }
}

struct BakBarView_Previews: PreviewProvider {
    static var previews: some View {
        BakBarView(currentAccent: .medium, bakInt: 1, barHeight: 280, barWidth: 30.42, barColor: .bakbarActive, strongAccentIntColor: .bakbarnumberBlack, elseAccentIntColor: .bakbarnumberWhite, accent: {}) // 박 숫자 표시
    }
}
