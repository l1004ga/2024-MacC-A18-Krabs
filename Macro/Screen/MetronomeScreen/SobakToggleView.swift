//
//  SobakToggleView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct SobakToggleView: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
            HStack {
                Text("소박 보기")
                    .font(.Title3_R)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .toggleOn))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
            )
            .padding(.horizontal, 16)
    }
}


//#Preview {
//    SobakToggleView()
//}
