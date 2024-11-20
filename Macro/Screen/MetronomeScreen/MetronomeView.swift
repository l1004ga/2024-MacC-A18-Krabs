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
    
    @State private var jangdan: Jangdan
    @State private var isSobakOn: Bool = false
    
    @State private var initialJangdanAlert: Bool = false
    
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    
    @AppStorage("isBeepSound") var isBeepSound: Bool = false
    
    init(viewModel: MetronomeViewModel, jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = viewModel
    }
    
    
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
                            viewModel.effect(action: .changeAccent(row: row, daebak: daebak, sobak: sobak, accent: newAccent))
                        }
                    }
                    if let sobakSegmentCount = self.viewModel.state.currentJangdan?.sobakSegmentCount {
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
            SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdan)
                .padding(.bottom, 16)
            
            
            MetronomeControlView(viewModel: viewModel)
            
        }
        .task {
            self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
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
                Text("\(jangdan.name)")
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
                                // TODO: 완료 시 선택된장단 데이터 초기화
                            }
                        }
                    } message: {
                        Text("기본값으로 되돌리겠습니까?")
                    }
                    
                    Menu {
                        Button {
                            isBeepSound.toggle()
                        } label: {
                            HStack {
                                if isBeepSound {
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
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                // TODO: 완료 실행 시 장단 저장 프로세스 추가 필요
                                //
                                
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
