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
    
    init(viewModel: MetronomeViewModel, jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            HanbaeBoardView(
                jangdan: viewModel.state.jangdanAccent,
                isSobakOn: viewModel.state.isSobakOn,
                isPlaying: viewModel.state.isPlaying,
                currentRow: viewModel.state.currentRow,
                currentDaebak: viewModel.state.currentDaebak,
                currentSobak: viewModel.state.currentSobak
            ) { row, daebak, sobak in
                viewModel.effect(action: .changeAccent(row: row, daebak: daebak, sobak: sobak))
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 26)
            
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
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}
