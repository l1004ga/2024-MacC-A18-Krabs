//
//  SobakToggleView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct SobakToggleView: View {
    
    @Binding var isSobakOn: Bool
    var jangdan: Jangdan?
    
    var body: some View {
            HStack {
                Text("소박 보기")
                    .font(.Title3_R)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Toggle("", isOn: $isSobakOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .buttonToggleOn))
                    .disabled(jangdan == .엇중모리 || jangdan == .진양)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundCard)
            )
            .padding(.horizontal, 16)
    }
}


//#Preview {
//    SobakToggleView()
//}
