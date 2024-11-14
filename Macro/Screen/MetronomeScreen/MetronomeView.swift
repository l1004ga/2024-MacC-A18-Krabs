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
    @State private var isSheetPresented: Bool = false
    @State private var isSobakOn: Bool = false
    @State private var isPendulumOn: Bool = false
    
    init(viewModel: MetronomeViewModel, jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = viewModel
        self.isSobakOn = self.viewModel.state.isSobakOn
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            HanbaeBoardView(
                jangdan: viewModel.state.jangdanAccent,
                isSobakOn: viewModel.state.isSobakOn,
                isPlaying: viewModel.state.isPlaying,
                currentDaebak: viewModel.state.currentDaebak,
                currentSobak: viewModel.state.currentSobak
            ) { daebak, sobak in
                viewModel.effect(action: .changeAccent(daebak: daebak, sobak: sobak))
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 26)
            
            SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdan)
                .padding(.bottom, 16)
            
            
            MetronomeControlView(viewModel: viewModel)
            
        }
        .task {
            self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
        .onChange(of: self.viewModel.state.pendulumTrigger) { _, newValue in
            let meanTempo = 60.0 / Double(self.viewModel.state.bpm)
            let hanbaeTempo = meanTempo * Double(self.viewModel.state.daebakCount)
            let sobakTempo = hanbaeTempo / Double(self.viewModel.state.bakCount)
            let resultTempo =  sobakTempo * Double(self.viewModel.state.jangdanAccent[self.viewModel.state.currentDaebak].count)
            
            withAnimation(.easeInOut(duration: resultTempo)) {
                self.isPendulumOn = newValue
            }
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
                Button(action: {
                    isSheetPresented.toggle()
                }) {
                    HStack(spacing: 0) {
                        Text("\(jangdan.name)")
                            .font(.Body_R)
                            .foregroundStyle(.textSecondary)
                            .padding(.trailing, 6)
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.textSecondary)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSheetPresented) {
            JangdanSelectSheetView(jangdan: $jangdan, isSheetPresented: $isSheetPresented, sendJangdan: {
                self.viewModel.effect(action: .stopMetronome)
                self.isSobakOn = false // view의 소박보기 false
                self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
            })
            .presentationDragIndicator(.visible)
        }
    }
}
