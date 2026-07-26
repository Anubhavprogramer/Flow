//
//  BottomToolbar.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI

import SwiftUI

struct BottomToolbar: View {
    @ObservedObject var viewModel: CanvasViewModel
    
    let wireframeColors: [Color] = [.black, .gray, .blue, .red, .green]
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            // Quick Color Picker (visible when draw tool active)
            if viewModel.selectedToolType != .eraser && viewModel.selectedToolType != .lasso {
                HStack(spacing: AppSpacing.m) {
                    ForEach(wireframeColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: viewModel.selectedColor == color ? 2.5 : 0)
                            )
                            .shadow(radius: viewModel.selectedColor == color ? 2 : 0)
                            .scaleEffect(viewModel.selectedColor == color ? 1.2 : 1.0)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2)) {
                                    viewModel.selectColor(color)
                                }
                            }
                    }
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.vertical, AppSpacing.xxs)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            
            // Main Tool Picker & Actions
            HStack(spacing: AppSpacing.s) {
                ForEach(WireframeToolType.allCases) { tool in
                    Button {
                        withAnimation(.spring(response: 0.2)) {
                            viewModel.selectTool(tool)
                        }
                    } label: {
                        Image(systemName: tool.iconName)
                            .font(.system(size: 20, weight: viewModel.selectedToolType == tool ? .bold : .regular))
                            .foregroundStyle(viewModel.selectedToolType == tool ? Color.primary : Color.secondary)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(viewModel.selectedToolType == tool ? Color.accentColor.opacity(0.2) : Color.clear)
                            )
                    }
                }
                
                Divider()
                    .frame(height: 24)
                
                Button {
                    withAnimation {
                        viewModel.clearCanvas()
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundStyle(.red)
                        .padding(8)
                }
            }
            .padding(.horizontal, AppSpacing.m)
            .padding(.vertical, AppSpacing.xs)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        }
        .padding(.bottom, AppSpacing.s)
    }
}
