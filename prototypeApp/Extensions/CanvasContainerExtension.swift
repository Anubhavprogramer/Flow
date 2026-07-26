//
//  CanvasContainerExtension.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import PencilKit

extension CanvasContainer {
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: CanvasContainer
        
        init(parent: CanvasContainer) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }
}
