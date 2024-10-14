//
//  MetronomeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct MetronomeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var jangdan: String
    @State private var isSheetPresented: Bool = false
    @State private var isOn: Bool = false
    @State private var isPlaying: Bool = false
    
    @State private var circleXPosition: CGFloat = 0.0
    @State private var movingRight: Bool = true // 원이 오른쪽으로 이동 중인지 추적
    @State private var timer: Timer? = nil
    
    init(jangdan: String) {
        self.jangdan = jangdan
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                daebakPendulumView()
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
                SobakToggleView(isOn: $isOn)
                    .padding(.bottom, 16)
                
                MetronomeControlView(isPlaying: $isPlaying)
                
            }
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    startMoving(currentBpm: 45, geoSize: geo.size)
                } else {
                    stopMoving()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 뒤로가기 chevron
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
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
                        HStack(spacing: 6) {
                            Text("\(jangdan)")
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
            .toolbarBackground(.navigationBarBackground, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible)
            .toolbarTitleDisplayMode(.inline)
            .sheet(isPresented: $isSheetPresented) {
                JangdanSelectSheetView(jangdan: $jangdan, isSheetPresented: $isSheetPresented)
                    .presentationDragIndicator(.visible)
            }
            .onAppear {
                circleXPosition = 0
            }
        }
    }
    
    // 대박 펜듈럼 뷰
    @ViewBuilder
    func daebakPendulumView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 100)
                .frame(height: 16)
                .foregroundStyle(.bakBarInactive) // 임시 색상
                .padding(.horizontal, 8)
            
            Circle()
                .frame(width: 16)
                .offset(x: circleXPosition + 8)
        }
        .frame(maxWidth: .infinity)
    }
    
    
    // 팬듈럼 작동 함수
    func startMoving(currentBpm: Int, geoSize: CGSize) {
        let rectangleWidth: CGFloat = CGFloat(geoSize.width) - 16
        let bakTime: CGFloat = 60 / CGFloat(currentBpm)
        let distancePerSecond: CGFloat = (rectangleWidth - 16) / bakTime
        
        // 시작(실행)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            let movement: CGFloat = movingRight ? distancePerSecond * 0.01 : -distancePerSecond * 0.01
            
            circleXPosition += movement
            
            // 한쪽 끝에 도달하면 방향 반대로 변경
            if circleXPosition >= (rectangleWidth - 16) {
                movingRight = false
            } else if circleXPosition <= 0 {
                movingRight = true
            }
        }
    }
    
    // 타이머 중지 함수
    func stopMoving() {
        circleXPosition = 0
        timer?.invalidate() // 타이머 해제
        timer = nil
    }
}

//#Preview {
//    MetronomeView(jangdan: "휘모리")
//}
