//
//  CanvasModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI
import SwiftData
import PencilKit

@Model
final class CanvasScreen {
    
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    
    var createdAt: Date
    
    var updatedAt: Date
    
    @Attribute(.externalStorage)
    var drawingData: Data?
    
    @Relationship(deleteRule: .cascade)
    var elements: [CanvasElement]
    
    @Relationship
    var project: Project?
    
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = .now
        self.updatedAt = .now
        self.drawingData = nil
        self.elements = []
    }
    
    var drawing: PKDrawing {
        get {
            guard let drawingData, let drawing = try? PKDrawing(data: drawingData) else {
                return PKDrawing()
            }
            return drawing
        }
        set {
            drawingData = newValue.dataRepresentation()
            updatedAt = .now
        }
    }
}
