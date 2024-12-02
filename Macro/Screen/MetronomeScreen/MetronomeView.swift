//
//  MetronomeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI
import Combine

struct MetronomeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var viewModel: MetronomeViewModel
    
    @State private var appState: AppState = .shared
    
    private var jangdanName: String
    @State private var isSobakOn: Bool = false
    
    @State private var initialJangdanAlert: Bool = false
    
    @State private var exportJandanAlert: Bool = false
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.effect(action: .stopMetronome)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // 장단 선택 List title
            ToolbarItem(placement: .principal) {
                Text(jangdanName)
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
                    .padding(.trailing, 6)
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
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 내보내기", isPresented: $exportJandanAlert) {
                        TextField("장단명", text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { oldValue, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = oldValue
                                }
                            }
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                if !inputCustomJangdanName.isEmpty {
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
