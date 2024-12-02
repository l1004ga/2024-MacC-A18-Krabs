//
//  CustomJangdanPracticeView.swift
//  Macro
//
//  Created by Lee Wonsun on 11/26/24.
//

import SwiftUI

enum ToastType {
    case save
    case export(jangdanName: String)
    case changeName
    
    var massage: String {
        switch self {
        case .save:
            return "장단을 저장했습니다."
        case let .export(jangdanName):
            return "\(jangdanName) 내보내기가 완료되었습니다."
        case .changeName:
            return "장단명을 변경했습니다."
        }
    }
}

struct CustomJangdanPracticeView: View {
    @Environment(Router.self) var router
    
    @State var viewModel: MetronomeViewModel
    @State var customListViewModel: CustomJangdanListViewModel
    
    @State private var appState: AppState = .shared
    
    @State var jangdanName: String
    var jangdanType: String
    
    @State private var isSobakOn: Bool = false
    
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    @State private var toastType: ToastType = .save
    
    @State private var deleteJangdanAlert: Bool = false
    @State private var updateJandanNameAlert: Bool = false
    
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
                
                if toastAction {
                    Text(self.toastType.massage)
                        .font(.Body_R)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .foregroundStyle(Color.white)
                        .background(.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(self.toastOpacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeIn) {
                                    self.toastOpacity = 0
                                } completion: {
                                    self.toastAction = false
                                    self.toastOpacity = 1
                                }
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
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
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
                            self.customListViewModel.effect(action: .updateCustomJangdan(newJangdanName: nil))
                            self.toastType = .save
                            self.toastAction = true
                        } label: {
                            Text("장단 저장하기")
                        }
                        
                        
                        Button {
                            self.exportJandanAlert = true
                        } label: {
                            Text("장단 내보내기")
                        }
                        
                        Button {
                            self.inputCustomJangdanName = jangdanName
                            self.updateJandanNameAlert = true
                        } label: {
                            Text("장단이름 변경하기")
                        }
                        
                        
                        Button {
                            self.deleteJangdanAlert = true
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
                            .onChange(of: inputCustomJangdanName) { _, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = String(newValue.prefix(10))
                                }
                            }
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                    self.toastType = .export(jangdanName: self.inputCustomJangdanName)
                                    toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("저장된 장단명을 작성해주세요.")
                    }
                    .alert("장단이름 변경하기", isPresented: $updateJandanNameAlert) {
                        TextField(jangdanName, text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { _, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = String(newValue.prefix(10))
                                }
                            }
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                self.customListViewModel.effect(action: .updateCustomJangdan(newJangdanName: self.inputCustomJangdanName))
                                self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.inputCustomJangdanName))
                                self.jangdanName = self.viewModel.state.currentJangdanName ?? inputCustomJangdanName
                                self.toastType = .changeName
                                self.toastAction = true
                            }
                        }
                    } message: {
                        Text("새로운 장단명을 작성해주세요.")
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
