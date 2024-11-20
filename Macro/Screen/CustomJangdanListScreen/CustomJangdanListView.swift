//
//  CustomJangdanListView.swift
//  Macro
//
//  Created by jhon on 11/19/24.
//

import SwiftUI

struct CustomJangdanListView: View {
    let jangdanList: [(jangdanType: String, customJangdanName: String, createdDate: String)]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                if jangdanList.isEmpty {
                    ScrollView {
                        NavigationLink(destination: Text("커스텀장단 메트로놈 뷰")) {
                            NoCustomJangdanComponentView()
                                .frame(width: 361, height: 97)
                                .padding(.top, 32)
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(jangdanList.indices, id: \.self) { index in
                                let jangdan = jangdanList[index]
                                
                                NavigationLink(
                                    destination: CustomJangdanView(
                                        customJangdanName: jangdan.customJangdanName,
                                        instrument: .장구
                                    )
                                ) {
                                    CustomJangdanComponentView(
                                        jangdanType: jangdan.jangdanType,
                                        customJangdanName: jangdan.customJangdanName,
                                        createdDate: jangdan.createdDate
                                    )
                                    .frame(width: 361, height: 97)
                                }
                                .buttonStyle(PlainButtonStyle()) // 버튼 스타일 제거
                            }
                        }
                    }
                    .padding(.top, 32)
                }
            }
            .navigationTitle("내가 저장한 장단")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.textDefault)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("내가 저장한 장단")
                        .font(.Body_R)
                        .foregroundStyle(.textSecondary)
                        .padding(.trailing, 6)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            print("장단 만들기 선택됨")
                        }) {
                            Text("장단 만들기")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(role: .destructive, action: {
                            print("삭제 선택됨")
                        }) {
                            Text("삭제")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                        }
                    } label: {
                        Text("편집")
                            .font(.Body_R)
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
            .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

// MARK: 실험용 뷰
struct CustomJangdanView: View {
    let customJangdanName: String
    let instrument: Instrument
    
    var body: some View {
        VStack {
            Text("\(customJangdanName)")
            Text("\(instrument.rawValue)")
        }
    }
}

struct CustomJangdanListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 데이터가 없는 경우
            CustomJangdanListView(jangdanList: [])
            
            // 데이터가 있는 경우
            CustomJangdanListView(jangdanList: [
                (jangdanType: "자진모리", customJangdanName: "변형 자진모리", createdDate: "2024.11.19"),
                (jangdanType: "진양", customJangdanName: "느린 진양", createdDate: "2024.11.18")
            ])
        }
    }
}
