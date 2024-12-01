//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(Router.self) var router
    
    @State private var appState: AppState = .shared
    
    @State private var viewModel: HomeViewModel = DIContainer.shared.homeViewModel
    @State private var isSelectedJangdan: Bool = false
    @State private var buttonPressedStates: [Jangdan: Bool] = [:]
    
    private let columns: [GridItem] = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        if self.appState.didLaunchedBefore {
            NavigationStack(path: Binding(
                get: { router.path }, set: { router.path = $0 }
            ))
            {
                VStack(spacing: 0) {
                    HStack {
                        Menu {
                            Button("북") {
                                self.appState.setInstrument(.북)
                                self.viewModel.effect(action: .changeSoundType)
                            }
                            Button("장구") {
                                self.appState.setInstrument(.장구)
                                self.viewModel.effect(action: .changeSoundType)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text("\(self.appState.selectedInstrument.rawValue)")
                                    .font(.Callout_R)
                                    .frame(width: 30)
                                Image(systemName: "chevron.down")
                            }
                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 12))
                            .background {
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(lineWidth: 2)
                                    .clipShape(RoundedRectangle(cornerRadius: 35))
                            }
                            .foregroundStyle(.buttonReverse)
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        Image(systemName: "tray.full.fill")
                            .font(.system(size: 22))
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                            .onTapGesture {
                                router.push(.customJangdanList)
                            }
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 17)
                    
                    ScrollView() {
                        // MARK: - 기본 장단 목록 (2칸씩 수직 그리드)
                        VStack {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(self.appState.selectedInstrument.defaultJangdans, id: \.self) { jangdan in
                                    NavigationLink(jangdan.name, destination: MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdan.rawValue))
                                        .buttonStyle(JangdanLogoButtonStyle(jangdan: jangdan))
                                }
                            }
                        }
                        .padding(.top, 34)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, 16)
                    .navigationDestination(for: Route.self) { path in
                        router.view(for: path)
                    }
                }
            }
        } else {
            InstrumentsSelectView()
        }
    }
}

extension HomeView {
    private struct JangdanLogoButtonStyle: ButtonStyle {
        @State private var isPressed: Bool?
        
        var jangdan: Jangdan
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isPressed == true ? .buttonActive : .backgroundCard) // 배경색 설정
                    .shadow(radius: 5) // 그림자 효과
                    .overlay {
                        jangdan.jangdanLogoImage
                            .resizable()
                            .foregroundStyle(isPressed == true ? .backgroundImageActive : .backgroundImageDefault)
                            .frame(width: 225, height: 225)
                            .offset(y: -116)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(jangdan.name)
                    .font(isPressed == true ? .Title1_B : .Title1_R)
                    .foregroundStyle(isPressed == true ? .textButtonEmphasis : .textDefault)
                    .offset(y: -2.5)
                
                Text(jangdan.bakInformation)
                    .font(.Body_R)
                    .foregroundStyle(isPressed == true ? .textButtonEmphasis : .textDefault)
                    .offset(y: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .animation(nil, value: configuration.isPressed) // 기존 버튼에 따른 애니메이션은 제거
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if isPressed == nil { // 처음 탭될때만 버튼 Active
                            isPressed = true
                        } else { // 아니면 드래그 (스크롤) 중이라는 뜻이니까 deActive
                            withAnimation(.linear(duration: 0.2)) {
                                isPressed = false
                            }
                        }
                    }
                    .onEnded { _ in // 제스처 끝날때 도로 nil로 초기화
                        withAnimation {
                            isPressed = nil
                        }
                    }
            )
        }
    }
}

#Preview {
    HomeView()
        .environment(Router().self)
}
