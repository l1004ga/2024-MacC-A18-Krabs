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
    @State var geoSize: CGSize
    
    init(jangdan: String, geoSize: CGSize) {
        self.jangdan = jangdan
        self._geoSize = State(initialValue: geoSize)
    }
    
    
    var body: some View {
        
            VStack(spacing: 0) {
                
                SobakToggleView(geoSize: geoSize)
                    .padding(.bottom, geoSize.height * 0.019)
                
                MetronomeControlView(geoSize: geoSize)
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
                        HStack(spacing: geoSize.width * 0.015) {
                            Text("\(jangdan)")
                                .font(.Body_R)
                                .foregroundStyle(.textSecondary)
                                .padding(.trailing, geoSize.width * 0.015)
                            
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
                JangdanSelectSheetView(jangdan: $jangdan, isSheetPresented: $isSheetPresented, geoSize: geoSize)
                    .presentationDragIndicator(.visible)
            }
        
    }
}

//#Preview {
//    MetronomeView(jangdan: "휘모리")
//}
