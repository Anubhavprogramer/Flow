//
//  ElementModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftData
import Foundation

@Model
final class CanvasElement {
    @Attribute(.unique)
    var id: UUID
    
    var type: ElementType
    
    var x: Double
    
    var y: Double
    
    var width: Double
    var height: Double
    
    var rotation: Double
    
    var opacity: Double
    
    var locked: Bool
    
    var hidden: Bool
    
    var zIndex: Int
    
    init(type: ElementType, x: Double, y: Double, width: Double, height: Double, rotation: Double, opacity: Double, locked: Bool, hidden: Bool, zIndex: Int) {
        self.id = UUID()
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.opacity = opacity
        self.locked = locked
        self.hidden = hidden
        self.zIndex = zIndex
    }
}


enum ElementType: String, Codable {
    
    case rectangle
    case circle
    case text
    case image
    case icon
}
