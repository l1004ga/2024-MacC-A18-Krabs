//
//  JangdanSelectView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

// MARK: 사용하지 않는 뷰 삭제 필요
struct JangdanSelectView: View {
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("어떤 장단을 연습할까요?")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .padding(.leading, 16)
                
//                List {
//                    ForEach(Jangdan.allCases, id: \.self) { jangdan in
//                        NavigationLink(destination: MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdan.)) {
//                            Text("\(jangdan)")
//                                .padding(.vertical, 9)
//                        }
//                    }
//                }
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    JangdanSelectView()
}

