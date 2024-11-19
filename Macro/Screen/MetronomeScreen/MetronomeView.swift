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
    
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    
    @AppStorage("isBeepSound") var isBeepSound: Bool = false
    
    init(viewModel: MetronomeViewModel, jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                // TODO: if SobakSegment { SobakSegment() }
            }
            .frame(height: 372)
            .padding(.horizontal, 8)
            
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
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
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
                }
            }
        }
//        .alert(isPresented: $exportJandanAlert, content: {
//            Alert(title: Text("장단 내보내기"), message: Text("저장할 장단 이름을 작성해주세요."), primaryButton: .destructive(Text("취소")), secondaryButton: .default(Text("확인")))
//            
//        })
        .alert("장단 내보내기", isPresented: $exportJandanAlert) {
            TextField("장단명", text: $inputCustomJangdanName)
            HStack{
                Button("취소") { }
                Button("완료") { // TODO: 완료 동작 시 저장 프로세스 추가 필요 }
            }
        } message: {
            Text("저장된 장단명을 작성해주세요.")
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}
