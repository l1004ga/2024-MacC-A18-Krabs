//
//  CustomJangdanCreateView.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

struct CustomJangdanCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: MetronomeViewModel
    
    var jangdanName: String
    
    @State private var isSobakOn: Bool = false
    
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 12) {
                    HanbaeBoardView(
                        jangdan: viewModel.state.jangdanAccent,
                        isSobakOn: viewModel.state.isSobakOn,
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
                        SobakSegmentsView(sobakSegmentCount: sobakSegmentCount, currentSobak: self.viewModel.state.currentSobak, isPlaying: self.viewModel.state.isPlaying)
                    }
                }
                .frame(height: 372)
                .padding(.horizontal, 8)
            }
            SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdanType)
                .padding(.bottom, 16)
            
            MetronomeControlView(viewModel: viewModel)
            
        }
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
            self.isSobakOn = false
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // TODO: - Alert 띄우기 - 저장하지 않고 나갈건가용?
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.effect(action: .stopMetronome)
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // 장단 선택 List title
            ToolbarItem(placement: .principal) {
                Text("\(self.viewModel.state.currentJangdanName ?? "") 장단 만들기")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        // TODO: 데이터 초기화
                        initialJangdanAlert = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 설정 초기화", isPresented: $initialJangdanAlert) {
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                self.viewModel.effect(action: .initialJangdan)
                            }
                        }
                    } message: {
                        Text("기본값으로 되돌리겠습니까?")
                    }
                    
                    // TODO: - 완료
                    Button {
                        
                    } label: {
                        Text("완료")
                    }
                    .alert("저장할 장단 이름", isPresented: $exportJandanAlert) {
                        TextField("장단명", text: $inputCustomJangdanName)
                        HStack{
                            Button("취소") { }
                            Button("확인") {
                                self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                            }
                        }
                    } message: {
                        Text("저장될 이름을 작성해주세요.")
                    }
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    CustomJangdanCreateView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: "진양")
}
