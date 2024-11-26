//
//  CustomJangdanPracticeView.swift
//  Macro
//
//  Created by Lee Wonsun on 11/26/24.
//

import SwiftUI

struct CustomJangdanPracticeView: View {
    @Environment(Router.self) var router
    
    @State var viewModel: MetronomeViewModel
    @State var customListViewModel: CustomJangdanListViewModel
    
    @State private var appState: AppState = .shared
    
    var jangdanName: String
    var jangdanType: String
    
    @State private var isSobakOn: Bool = false
    
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    
    @State private var isAlertOn: Bool = false
    @State private var deleteJangdanAlert: Bool = false
    
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
            SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdanType)
                .padding(.bottom, 16)
            
            MetronomeControlView(viewModel: viewModel)
            
        }
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
            self.isSobakOn = false
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
        .onAppear { self.viewModel.effect(action: .resetAccentCount) }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if self.viewModel.state.accentChangedCount > 1 {
                        isAlertOn = true
                    } else {
                        router.pop()
                    }
                    self.viewModel.effect(action: .stopMetronome)
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
                .alert("수정된 내용을\n반영하고 나갈까요?", isPresented: $isAlertOn) {
                    HStack{
                        Button("확인") {
                            isAlertOn = false
                            self.viewModel.effect(action: .stopMetronome)
                            router.pop()
                            // TODO: (룰루) 수정 사항 UPDATE하기
                        }
                        Button("취소") {
                            isAlertOn = false
                            router.pop()
                        }
                    }
                }
            }
            
            
            // 연습 장단 이름
            ToolbarItem(placement: .principal) {
                Text("\(jangdanType) | \(jangdanName)")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200)
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
                                self.viewModel.effect(action: .resetAccentCount)
                            }
                        }
                    } message: {
                        Text("기본값으로 되돌리겠습니까?")
                    }
                    
                    Menu {
                        Button {
                            self.appState.toggleBeepSound()
                            self.viewModel.effect(action: .changeSoundType)
                        } label: {
                            HStack {
                                if self.appState.isBeepSound {
                                    Image(systemName: "checkmark")
                                }
                                Text("비프음으로 변환")
                            }
                        }
                        Button {
                            exportJandanAlert = true
                        } label: {
                            Text("장단 내보내기")
                        }
                        
                        Button {
                            deleteJangdanAlert = true
                        } label: {
                            Text("장단 삭제하기")
                        }

                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 삭제하기", isPresented: $deleteJangdanAlert) {
                        Button("예") {
                            deleteJangdanAlert = false
                            self.customListViewModel.effect(action: .deleteCustomJangdanData(jangdanName: jangdanName))
                            router.pop()
                        }
                        Button("아니오") {
                            deleteJangdanAlert = false
                        }
                    } message: {
                        Text("현재 장단을 삭제하시겠습니까?")
                    }
                    .alert("장단 내보내기", isPresented: $exportJandanAlert) {
                        TextField("장단명", text: $inputCustomJangdanName)
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                toastAction = true
                            }
                        }
                    } message: {
                        Text("저장된 장단명을 작성해주세요.")
                    }
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    CustomJangdanPracticeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: "진양")
//}
