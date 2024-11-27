//
//  viewSobakToggleView.swift
//  Macro
//
//  Created by leejina on 11/26/24.
//

import SwiftUI

struct ViewSobakToggleView: View {
    @Binding var isSobakOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.viewSobak)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 10)
            
            Text("소박 보기")
                .font(.Title3_R)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Toggle("", isOn: $isSobakOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .buttonToggleOn))
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

#Preview {
    @Previewable @State var isSobakOn: Bool = false
    ViewSobakToggleView(isSobakOn: $isSobakOn)
}
