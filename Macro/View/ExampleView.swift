//
//  ExampleView.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

struct ExampleView: View {
    @State var viewModel: ExampleViewModel = .init()
    
    var body: some View {
        VStack {
            Text(viewModel.state.name)
                
            Button("Im Eddie") {
                viewModel.effect(action: .tapButton)
            }
        }
    }
}

#Preview {
    ExampleView()
}
