//
//  PageScreenView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI

struct ScreenView: View{
    
    var screen: CanvasScreen
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject
    private var viewModel = CanvasViewModel()
    
    var body: some View{
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            CanvasContainer(drawing: $viewModel.drawing)
            
            VStack{
                Spacer()
                
                BottomToolbar()
            }
        }
        .navigationTitle(screen.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: AppStrings.doneButton)
                }
            }
        }
    }
}
