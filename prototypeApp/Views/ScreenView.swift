//
//  PageScreenView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI
import SwiftData

struct ScreenView: View {
    var screen: CanvasScreen
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = CanvasViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            CanvasContainer(
                drawing: $viewModel.drawing,
                tool: $viewModel.currentPKTool
            )
            
            VStack {
                Spacer()
                BottomToolbar(viewModel: viewModel)
            }
        }
        .navigationTitle(screen.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.saveDrawing(to: screen, context: context)
                    dismiss()
                } label: {
                    Image(systemName: AppStrings.doneButton)
                        .font(.body.weight(.bold))
                }
            }
        }
        .onAppear {
            viewModel.setupScreen(screen)
        }
        .onDisappear {
            viewModel.saveDrawing(to: screen, context: context)
        }
        .onChange(of: viewModel.drawing) { _, _ in
            viewModel.saveDrawing(to: screen, context: context)
        }
    }
}
