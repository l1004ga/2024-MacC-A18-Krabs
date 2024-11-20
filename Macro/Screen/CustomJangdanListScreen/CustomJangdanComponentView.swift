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
    @Binding var isEditing: Bool

    let deleteButtonWidth: CGFloat = 74 // 삭제 버튼의 고정 가로 길이

    var body: some View {
        ZStack {
            // 삭제 버튼
            if isEditing {
                HStack {
                    Button(action: {
                        // 삭제 동작 추가
                        print("삭제 버튼 눌림")
                    }) {
                        Text("삭제")
                            .font(.Subheadline_R)
                            .foregroundColor(.white)
                            .frame(width: deleteButtonWidth, height: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    Spacer()

                }

                .transition(.move(edge: .leading)) // 왼쪽에서 나타나는 애니메이션
            }
            
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
            // VStack에 애니메이션 적용
            .offset(x: isEditing ? deleteButtonWidth + 16 : 0) // 편집 모드에 따라 오른쪽으로 이동
            .animation(.easeInOut, value: isEditing) // 부드러운 애니메이션 추가
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
            customJangdanName: "어쩌구저쩌구",
            createdDate: "2024.12.31.",
            isEditing: .constant(false) // 편집 모드 활성화
        )
        .frame(width: 361, height: 97)
    }
}
