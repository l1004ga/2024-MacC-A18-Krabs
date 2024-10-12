//
//  SobakToggleView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct SobakToggleView: View {
    
    @State private var isOn: Bool = false
    
    // geometry 설정을 위한 변수
    @State var geoSize: CGSize = .zero
    
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
                .padding(.horizontal, geoSize.width * 0.1)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: geoSize.width * 0.92, height: geoSize.height * 0.0646)
                        .foregroundStyle(Color.cardBackground)
                }
        

    }
}


#Preview {
    SobakToggleView()
}
