//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(Router.self) var router
  
    @AppStorage("isSelectedInstrument") var isSelectedInstrument: Bool = false
    @AppStorage("selectInstrument") var selectInstrument: Instrument = .장구
    
    @State var viewModel: HomeViewModel = DIContainer.shared.homeViewModel
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        if self.isSelectedInstrument {
            NavigationStack(path: Binding(
                get: { router.path },set: { router.path = $0 }
            )) 
                {
                VStack {
                    HStack {
                        Menu {
                            Button("북") {
                                self.selectInstrument = .북
                                self.viewModel.effect(action: .changeSoundType)
                            }
                            Button("장구") {
                                self.selectInstrument = .장구
                                self.viewModel.effect(action: .changeSoundType)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text("\(self.selectInstrument)")
                                    .font(.Callout_R)
                                Image(systemName: "chevron.down")
                            }
                            .padding(.horizontal, 14)
                            .frame(width: 87, height: 42)
                            .background {
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(lineWidth: 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 35))
                            }
                            .foregroundStyle(.buttonReverse)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "tray.full.fill")
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
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 7.5), GridItem(.flexible())], spacing: 7.5) {
                                ForEach(Jangdan.allCases, id: \.self) { jangdan in
                                    NavigationLink(destination: MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdan.rawValue)) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.backgroundCard) // 배경색 설정
                                                .shadow(radius: 5) // 그림자 효과
                                                .overlay {
                                                    jangdan.jangdanLogoImage
                                                        .resizable()
                                                        .frame(width: 225, height: 225)
                                                        .offset(y: -100)
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                            
                                            Text(jangdan.name)
                                                .font(.Title1_R)
                                                .foregroundStyle(.textDefault)
                                                .offset(y: -2.5)
                                            
                                            Text(jangdan.bakInformation)
                                                .font(.Body_R)
                                                .foregroundStyle(.textDefault)
                                                .offset(y: 30)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fill)
                                    }
                                }
                            }
                        }
                        .padding(.top, 34)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, 16)
                    .navigationDestination(for: Route.self) { path in
                    switch path {
                    case .customJangdanList:
                        CustomJangdanListView(viewModel: DIContainer.shared.customJangdanListViewModel)
                    case .jangdanTypeSelect:
                        JangdanTypeSelectView()
                    case let .customJangdanCreate(jangdanName):
                        CustomJangdanCreateView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdanName)
                    }
                }
                }
            }        } else {
                InstrumentsSelectView()
            }
    }
}

#Preview {
    HomeView()
}