//
//  JangdanSelectView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct JangdanSelectView: View {
    
    let exampleList: [String] = ["진양", "중모리", "중중모리", "굿거리", "휘모리", "동살풀이", "엇모리", "엇중모리", "세마치", "노랫가락 5.8.8.5.5"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                
                
                Text("어떤 장단을 연습할까요?")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .padding(.leading, 16)
                
                List {
                    ForEach(exampleList, id: \.self) { jangdan in
                        NavigationLink(destination: MetronomeView(jangdan: jangdan)) {
                            Text("\(jangdan)")
                                .padding(.vertical, 8)
                        }
                    }
                }
//                .scrollDisabled(true)
                
            }
            .padding(.top, 69.5)
        }
    }
}

#Preview {
    JangdanSelectView()
}

