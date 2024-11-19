//
//  CustomJangdanComponentView.swift
//  Macro
//
//  Created by jhon on 11/19/24.
//

import SwiftUI

struct CustomJangdanComponentView: View {
    let jangdanType: String
    let customJangdanName: String
    let createdDate: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Text("\(jangdanType)")
                        .font(.Subheadline_R)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                    Text("\(createdDate)")
                        .font(.Subheadline_R)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 19)
                }
                Text(customJangdanName)
                    .font(.Title3_R)
                    .foregroundColor(.textDefault)
                    .padding(.leading, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundCard)
        .cornerRadius(16)
    }
}




struct CustomJangdanComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CustomJangdanComponentView(
            jangdanType: "자진모리",
            customJangdanName: "어ㄷ쩌구저쩌구",
            createdDate: "2024.12.31."
        )
        .frame(width: 361, height: 97) // 기본 크기 설정
    }
}
