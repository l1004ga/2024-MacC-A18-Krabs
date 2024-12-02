//
//  CustomJangdanCreateView.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

struct CustomJangdanCreateView: View {
    @Environment(Router.self) var router
    
    @State var viewModel: MetronomeViewModel
    
    var jangdanName: String
    
    @State private var isSobakOn: Bool = false
    
    @State private var backButtonAlert: Bool = false
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    
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
                    }
                }
                .frame(height: 372)
                .padding(.horizontal, 8)
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
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
            self.isSobakOn = false
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.viewModel.effect(action: .stopMetronome)
                    backButtonAlert = true
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
                .alert("저장하지 않고\n나가시겠습니까?", isPresented: $backButtonAlert) {
                    HStack{
                        Button("취소") { }
                        Button("나가기") {
                            self.viewModel.effect(action: .stopMetronome)
                            router.pop()
                        }
                    }
                }
            }
            
            
            // 장단 선택 List title
            ToolbarItem(placement: .principal) {
                Text("\(self.viewModel.state.currentJangdanName ?? "") 장단 만들기")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
            
            // 현재 장단 저장하기
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    // 초기화 버튼
                    Button {
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
                    
                    // 장단 저장 버튼
                    Button {
                        exportJandanAlert = true
                    } label: {
                        Text("저장")
                            .font(.Body_R)
                            .foregroundStyle(.textDefault)
                    }
                    .alert("저장할 장단 이름", isPresented: $exportJandanAlert) {
                        TextField("이름", text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { _, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = String(newValue.prefix(10))
                                }
                            }
                        HStack{
                            Button("취소") { }
                            Button("확인") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .stopMetronome)
                                    self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                    router.pop(2)
                                }
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
        .environment(Router().self)
}
