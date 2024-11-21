//
//  InstrumentsSelectView.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

import SwiftUI

struct InstrumentsSelectView: View {
    var body: some View {
        ZStack {
            VStack {
                // 뷰 정렬의 기준점 : vertical 기준 가운데 위치해야 함
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 16)
                    RoundedRectangle(cornerRadius: 16)
                }
                .frame(height: 272)
                .padding(.horizontal, 24)
            }
            
            VStack {
                Text("메트로놈 소리를 \n 선택해주세요.")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 120)
                Spacer()
                VStack(spacing: 32) {
                    Text("악기에 맞춰진 장단을 들을 수 있어요.\n판소리에 특화된 장단이 제공돼요.")
                        .font(.Subheadline_R)
                        .foregroundStyle(.textTertiary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("시작")
                        .font(.Title1_B)
                        .bold()
                        .foregroundStyle(.textButtonEmphasis)
                        .padding(.vertical, 18.5)
                        .frame(minWidth: 70, maxWidth: 337)
                        .background(.buttonPlayStart)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .padding(.bottom, 36)
            }
        }
    }
}

#Preview {
    InstrumentsSelectView()
}
