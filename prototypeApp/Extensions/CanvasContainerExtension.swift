//
//  CanvasContainerExtension.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import PencilKit
import SwiftUI

extension CanvasContainer {
    final class Coordinator: NSObject, PKCanvasViewDelegate, UIGestureRecognizerDelegate {
        let parent: CanvasContainer
        var isUserDrawing: Bool = false
        private var endDrawingWorkItem: DispatchWorkItem?
        
        init(parent: CanvasContainer) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                if self.parent.drawing != canvasView.drawing {
                    self.parent.drawing = canvasView.drawing
                }
            }
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            switch gesture.state {
            case .began, .changed:
                endDrawingWorkItem?.cancel()
                if !isUserDrawing {
                    isUserDrawing = true
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.parent.isDrawing = true
                        }
                    }
                }
            case .ended, .cancelled, .failed:
                isUserDrawing = false
                endDrawingWorkItem?.cancel()
                let workItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.parent.isDrawing = false
                    }
                }
                endDrawingWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
            default:
                break
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
