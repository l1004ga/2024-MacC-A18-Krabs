//
//  JangdanSelectView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct JangdanSelectView: View {
    
    // 임시 데이터
    let exampleList: [String] = ["진양", "중모리", "중중모리", "굿거리", "휘모리", "동살풀이", "엇모리", "엇중모리", "세마치", "노랫가락 5.8.8.5.5"]
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    
                    Text("어떤 장단을 연습할까요?")
                        .font(.Title1_R)
                        .foregroundStyle(.textDefault)
                        .padding(.leading, geo.size.width * 0.041)
                    
                    List {
                        ForEach(exampleList, id: \.self) { jangdan in
                            NavigationLink(destination: MetronomeView(jangdan: jangdan, geoSize: geo.size)) {
                                Text("\(jangdan)")
                                    .padding(.vertical, geo.size.height * 0.011)
                            }
                        }
                    }
                    
                }
                .padding(.top, geo.size.height * 0.082)
            }
        }
    }
}

#Preview {
    JangdanSelectView()
}

