//
//  CustomJangdanListView.swift
//  Macro
//
//  Created by jhon on 11/19/24.
//

import SwiftUI

struct CustomJangdanListView: View {
    @Environment(\.dismiss) var dismiss
    
    let jangdanList: [(jangdanType: Jangdan, customJangdanName: String, createdDate: Date)]
    
    var body: some View {
        List {
            if jangdanList.isEmpty {
                ZStack {
                    EmptyJangdanListView()
                        .padding(.horizontal, 16)
                    
                    NavigationLink {
                        Text("커스텀장단 생성 뷰")
                    } label: {
                        
                    }
                    .opacity(0)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            } else {
                ForEach(jangdanList, id: \.customJangdanName) { jangdan in
                    ZStack {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(jangdan.jangdanType.name)
                                    .font(.Subheadline_R)
                                    .foregroundStyle(.textSecondary)
                                
                                Text(jangdan.customJangdanName)
                                    .font(.Title3_R)
                                    .foregroundStyle(.textDefault)
                            }
                            
                            Spacer()
                            
                            Text("날짜")
                                .font(.Subheadline_R)
                                .foregroundStyle(.textSecondary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(.backgroundCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        .padding(.horizontal, 16)
                        
                        NavigationLink {
                            Text("커스텀장단 메트로놈 뷰")
                        } label: {
                            
                        }
                        .opacity(0)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .onDelete { _ in
                    
                }
            }
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .padding(.top, 32)
        .toolbar {
            // MARK: - 뒤로가기
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // MARK: - Title
            ToolbarItem(placement: .principal) {
                Text("내가 저장한 장단")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .foregroundStyle(.textDefault)
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CustomJangdanListView(jangdanList: [])
}
