//
//  CanvasViewModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//
import Combine
import PencilKit
import SwiftUI
import SwiftData

enum WireframeToolType: String, CaseIterable, Identifiable {
    case pen
    case pencil
    case marker
    case eraser
    case lasso
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .pen: return "pencil.tip"
        case .pencil: return "pencil"
        case .marker: return "highlighter"
        case .eraser: return "eraser"
        case .lasso: return "lasso"
        }
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published var drawing = PKDrawing()
    @Published var selectedToolType: WireframeToolType = .pen
    @Published var selectedColor: Color = .black
    @Published var strokeWidth: CGFloat = 4.0
    @Published var currentPKTool: PKTool = PKInkingTool(.pen, color: .black, width: 4.0)
    
    private var isInitialized = false
    
    func setupScreen(_ screen: CanvasScreen) {
        guard !isInitialized else { return }
        self.drawing = screen.drawing
        self.isInitialized = true
        updateTool()
    }
    
    func updateTool() {
        let uiColor = UIColor(selectedColor)
        switch selectedToolType {
        case .pen:
            currentPKTool = PKInkingTool(.pen, color: uiColor, width: strokeWidth)
        case .pencil:
            currentPKTool = PKInkingTool(.pencil, color: uiColor, width: strokeWidth * 0.75)
        case .marker:
            currentPKTool = PKInkingTool(.marker, color: uiColor.withAlphaComponent(0.5), width: strokeWidth * 2.5)
        case .eraser:
            currentPKTool = PKEraserTool(.vector)
        case .lasso:
            currentPKTool = PKLassoTool()
        }
    }
    
    func selectTool(_ toolType: WireframeToolType) {
        selectedToolType = toolType
        updateTool()
    }
    
    func selectColor(_ color: Color) {
        selectedColor = color
        if selectedToolType == .eraser || selectedToolType == .lasso {
            selectedToolType = .pen
        }
        updateTool()
    }
    
    func clearCanvas() {
        drawing = PKDrawing()
    }
    
    func saveDrawing(to screen: CanvasScreen, context: ModelContext) {
        screen.drawing = drawing
        do {
            try context.save()
        } catch {
            print("Failed to save drawing: \(error.localizedDescription)")
        }
    }
}
