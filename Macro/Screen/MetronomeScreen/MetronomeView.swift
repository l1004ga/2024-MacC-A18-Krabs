//
//  MetronomeView.swift
//  Macro
//
//  Created by Yunki on 12/16/24.
//

import SwiftUI

struct MetronomeView: View {
    @State var viewModel: MetronomeViewModel
    
    private var jangdanName: String
    @State private var isSobakOn: Bool = false
    
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    
    init(viewModel: MetronomeViewModel, jangdanName: String) {
        self.jangdanName = jangdanName
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 12) {
                    HanbaeBoardView(
                        jangdan: viewModel.state.jangdanAccent,
                        isSobakOn: self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? viewModel.state.isSobakOn : false,
                        isPlaying: viewModel.state.isPlaying,
                        currentRow: viewModel.state.currentRow,
                        currentDaebak: viewModel.state.currentDaebak,
                        currentSobak: viewModel.state.currentSobak
                    ) { row, daebak, sobak, newAccent in
                        withAnimation {
                            viewModel.effect(action: .changeAccent(row: row, daebak: daebak, sobak: sobak, newAccent: newAccent))
                        }
                    }
                    if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                        SobakSegmentsView(sobakSegmentCount: sobakSegmentCount, currentSobak: self.viewModel.state.currentSobak, isPlaying: self.viewModel.state.isPlaying, isSobakOn: self.viewModel.state.isSobakOn)
                            .padding(.bottom, -4)
                    }
                }
                .frame(height: 372)
                .padding(.horizontal, 8)
                if toastAction {
                    Text("'\(inputCustomJangdanName)' 내보내기가 완료되었습니다.")
                        .font(.Body_R)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .foregroundStyle(Color.white)
                        .background(.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(self.toastOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 3)) {
                                self.toastOpacity = 0
                            } completion: {
                                self.toastAction = false
                                self.toastOpacity = 1
                            }
                        }
                }
            }
            if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                ViewSobakToggleView(isSobakOn: $isSobakOn)
                    .padding(.bottom, 16)
            } else {
                ListenSobakToggleView(isSobakOn: $isSobakOn)
                    .padding(.bottom, 16)
            }
            MetronomeControlView(viewModel: viewModel)
        }
        // 빠르기 찾기 기능 비활성화 용도
        .contentShape(Rectangle())
        .onTapGesture {
            self.viewModel.effect(action: .disableEstimateBpm)
        }
        
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
            self.isSobakOn = self.viewModel.state.isSobakOn
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
    }
}

#Preview {
    MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: "진양")
}
