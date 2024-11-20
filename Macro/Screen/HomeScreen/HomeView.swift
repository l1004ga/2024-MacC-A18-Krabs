//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: - 악기 선택 버튼(예정)
                HStack {
                    HStack {
                        Text("장구")
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .background {
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(lineWidth: 4)
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                    }
                    
                    Spacer()
                }
                
                // MARK: - 장식용 멘트
                Text("한배를 완벽하게 깎아봐요")
                    .padding(.vertical, 52)
                
                // MARK: - 커스텀 장단 목록 (가로 스크롤)
                VStack {
                    HStack {
                        Text("내가 저장한 장단")
                        Spacer()
                        // TODO: - 더보기뷰로 가는 버튼 (진)
                        Text("더보기")
                    }
                    
                    // TODO: - 진짜로 저장돼있는 장단 불러오기
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(0..<4) { _ in
                                // TODO: - 해당 장단을 재생하는 MetronomeView로 연결하는 버튼이 될 예정
                                HStack {
                                    VStack(alignment: .leading, spacing: 18) {
                                        Text("자진모리")
                                        Text("흥부가 돈타령")
                                    }
                                    Spacer()
                                }
                                .frame(width: 150)
                                .padding(.horizontal, 14)
                                .padding(.top, 16)
                                .padding(.bottom, 22)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.gray)
                                }
                            }
                        }
                    }
                }
                
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
            }
        }
    }
}

#Preview {
    HomeView()
}
