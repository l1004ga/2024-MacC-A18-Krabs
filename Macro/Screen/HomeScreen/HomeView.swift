//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("isSelectedInstrument") var isSelectedInstrument: Bool = true
    @AppStorage("selectInstrument") var selectInstrument: Instrument = .장구
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        if self.isSelectedInstrument {
            NavigationStack {
                VStack {
                    HStack {
                        Menu {
                            Button("북") {
                                self.selectInstrument = .북
                            }
                            Button("장구") {
                                self.selectInstrument = .장구
                            }
                        } label: {
                            HStack {
                                Text("\(self.selectInstrument)")
                                Image(systemName: "chevron.down")
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 38)
                            .background {
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(lineWidth: 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 35))
                            }
                            .foregroundStyle(.buttonReverse)
                        }
                        
                        Spacer()
                        NavigationLink {
                            CustomJangdanListView(jangdanList: [])
                        } label: {
                            Image(systemName: "tray.full.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.textSecondary)
                        }
                        .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView() {
                        // MARK: - 기본 장단 목록 (2칸씩 수직 그리드)
                        VStack {
                            HStack {
                                Text("기본 장단")
                                Spacer()
                            }
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 7), GridItem(.flexible())], spacing: 12) {
                                ForEach(Jangdan.allCases, id: \.self) { jangdan in
                                    // TODO: - 해당 장단을 재생하는 MetronomeView로 연결하는 버튼이 될 예정
                                    NavigationLink(destination: MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdan.rawValue)) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 15) {
                                                Text(jangdan.name)
                                                
                                                VStack(alignment: .leading) {
                                                    HStack(alignment: .bottom) {
                                                        Text("최근 연습률")
                                                        Spacer()
                                                        
                                                        // TODO: - 조각품 (진), 숙련도도 반영 예정
                                                        Circle()
                                                            .frame(width: 60, height: 60)
                                                    }
                                                    
                                                    // TODO: - 숙련도 반영 예정
                                                    ZStack(alignment: .leading) {
                                                        RoundedRectangle(cornerRadius: 50)
                                                            .fill(.black)
                                                        RoundedRectangle(cornerRadius: 50)
                                                            .fill(.orange)
                                                            .frame(width: 40)
                                                    }
                                                    .frame(height: 4)
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                                        .tint(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 14)
                                        .padding(.top, 6)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.gray)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 34)
                    }
                    .padding(.horizontal, 16)
                }
            }
        } else {
            InstrumentsSelectView()
        }
    }
}

#Preview {
    HomeView()
}
