//
//  MetronomeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct MetronomeView: View {
    let jangdan: String
    
    var body: some View {
        VStack {
            Text("Now practicing \(jangdan)")
                .font(.largeTitle)
                .padding()
            // 여기에 메트로놈 관련 뷰를 추가하세요.
        }
    }
}

#Preview {
    MetronomeView(jangdan: "휘모리")
}
