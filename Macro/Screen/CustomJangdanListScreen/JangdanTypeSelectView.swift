//
//  JangdanTypeSelectView.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

struct JangdanTypeSelectView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("만들 장단의\n종류를 선택해주세요.")
                .multilineTextAlignment(.leading)
                .font(.Title1_R)
                .foregroundStyle(.textDefault)
                .padding(.leading, 20)
                .padding(.top, 36)
                
            
            List {
                // TODO: - 악기 종류에 따라 표시되는 장단 리스트 달라야함
                ForEach(Jangdan.allCases, id: \.self) { jangdan in
                    NavigationLink {
                        // MARK: - CustomJangdanCreateView 로 이동
                    } label: {
                        Text(jangdan.name)
                            .foregroundStyle(.primary)
                            .padding(.vertical, 9)
                    }
                    
                }
                
            }
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            // 뒤로가기버튼
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // Title
            ToolbarItem(placement: .principal) {
                Text("장단 만들기")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    JangdanTypeSelectView()
}
