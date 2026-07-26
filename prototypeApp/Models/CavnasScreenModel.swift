//
//  CanvasModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI
import SwiftData

@Model
final class CanvasScreen {
    
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    
    var createdAt: Date
    
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade)
    var elements: [CanvasElement]
    
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = .now
        self.updatedAt = .now
        self.elements = []
    }
    
}
