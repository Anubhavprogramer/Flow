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
    
    func makeUIView(context: Context) -> some PKCanvasView {
        let canvas = PKCanvasView()
        
        canvas.backgroundColor = .white
        
        canvas.drawing = drawing
        
        canvas.drawingPolicy = .anyInput
        
        canvas.tool = PKInkingTool(
            .pen,
            color: .black,
            width: 5
        )
        
        canvas.delegate = context.coordinator
        
        canvas.isOpaque = false
        
        canvas.alwaysBounceVertical = false
        
        canvas.alwaysBounceHorizontal = false
        
        canvas.minimumZoomScale = 1
        
        canvas.maximumZoomScale = 4
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

