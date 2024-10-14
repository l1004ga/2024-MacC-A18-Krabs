//
//  JangdanSelectSheetView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct JangdanSelectSheetView: View {
    
    let exampleList: [String] = ["진양", "중모리", "중중모리", "굿거리", "휘모리", "동살풀이", "엇모리", "엇중모리", "세마치", "노랫가락 5.8.8.5.5"]
    
    @Binding var jangdan: String
    @Binding var isSheetPresented: Bool
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                // 우상단 창닫기 버튼
                Button(action: {
                    isSheetPresented = false
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)  // TODO: change color name
                            .font(.system(size: 30))
                            .padding(.bottom, 17.5)
                            .padding(.trailing, 16)
                    }
                })
          
                Text("다른 장단 선택하기")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .padding(.leading, 16)
                
                List {
                    ForEach(exampleList, id: \.self) { jangdan in
                        Button(action: {
                            self.jangdan = jangdan
                            isSheetPresented = false
                        }, label: { 
                                Text("\(jangdan)")
                                    .padding(.vertical, 9)
                                    .foregroundStyle(.white)
                        })
                    }
                }
                
            }
            .padding(.top, 14)
    }
}

//#Preview {
////    JangdanSelectSheetView()
//}
