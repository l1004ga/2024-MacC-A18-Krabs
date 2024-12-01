//
//  InstrumentsSelectView.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

import SwiftUI

struct InstrumentsSelectView: View {
    
    @State private var appState: AppState = .shared
    
    @State private var isSelected: Bool = false
    @State private var instrumentType: Instrument?
    
    var body: some View {
        ZStack {
            VStack {
                // 뷰 정렬의 기준점 : vertical 기준 가운데 위치해야 함
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(self.isSelected ? self.instrumentType == .북 ? .buttonActive.opacity(0.2) : .backgroundCard : .backgroundCard)
                            .stroke(.buttonActive, lineWidth: self.isSelected ? self.instrumentType == .북 ? 2 : 0 : 0)
                        Image(self.isSelected ? self.instrumentType == .북 ? .bukActive : .bukDefault : .bukDefault)
                            .resizable()
                            .frame(width: 96, height: 96)
                        Text("북")
                            .font(.Title2_B)
                            .foregroundStyle(self.isSelected ? self.instrumentType == .북 ? .textDefault : .textTertiary : .textTertiary)
                    }
                    .onTapGesture {
                        self.isSelected = true
                        self.instrumentType = .북
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(self.isSelected ? self.instrumentType == .장구 ? .buttonActive.opacity(0.2) : .backgroundCard : .backgroundCard)
                            .stroke(.buttonActive, lineWidth: self.isSelected ? self.instrumentType == .장구 ? 2 : 0 : 0)
                        Image(self.isSelected ? self.instrumentType == .장구 ? .jangGuActive : .jangGuDefault : .jangGuDefault)
                            .resizable()
                            .frame(width: 96, height: 96)
                        Text("장구")
                            .font(.Title2_B)
                            .foregroundStyle(self.isSelected ? self.instrumentType == .장구 ? .textDefault : .textTertiary : .textTertiary)
                    }
                    .onTapGesture {
                        self.isSelected = true
                        self.instrumentType = .장구
                    }
                }
                .frame(height: 272)
                .padding(.horizontal, 24)
            }
            
            VStack {
                Text("메트로놈 소리를\n선택해주세요.")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 120)
                Spacer()
                if isSelected {
                    VStack(spacing: 32) {
                        Text("악기에 맞춰진 장단을 들을 수 있어요.\n\(self.instrumentType == .북 ? "판소리" : "민요")에 특화된 장단이 제공돼요.")
                            .font(.Subheadline_R)
                            .foregroundStyle(.textTertiary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Button {
                            guard let instrumentType = self.instrumentType else { return }
                            self.appState.setInstrument(instrumentType)
                            self.appState.appLaunched()
                        } label: {
                            Text("시작")
                                .font(.Title1_B)
                                .bold()
                                .foregroundStyle(.textButtonEmphasis)
                                .padding(.vertical, 18.5)
                                .frame(minWidth: 70, maxWidth: 337)
                                .background(.buttonPlayStart)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                    }
                    .padding(.bottom, 36)
                }
            }
        }
    }
}

#Preview {
    InstrumentsSelectView()
        .environment(Router().self)
}
