//
//  CanvasContainer.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI
import PencilKit

struct CanvasContainer: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var tool: PKTool
    @Binding var isDrawing: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        
        canvas.backgroundColor = .clear
        canvas.drawing = drawing
        canvas.drawingPolicy = .anyInput
        canvas.tool = tool
        canvas.delegate = context.coordinator
        canvas.isOpaque = false
        canvas.alwaysBounceVertical = false
        canvas.alwaysBounceHorizontal = false
        canvas.minimumZoomScale = 1
        canvas.maximumZoomScale = 4
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.delegate = context.coordinator
        canvas.addGestureRecognizer(panGesture)
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing && !context.coordinator.isUserDrawing {
            uiView.drawing = drawing
        }
        uiView.tool = tool
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

