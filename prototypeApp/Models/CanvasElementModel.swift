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
    var title: String
    var iconName: String
    
    var x: Double
    var y: Double
    
    var width: Double
    var height: Double
    
    var rotation: Double
    var opacity: Double
    
    var locked: Bool
    var hidden: Bool
    
    var zIndex: Int
    
    var targetScreenID: UUID?
    
    var backgroundColorHex: String?
    var textColorHex: String?
    
    init(
        type: ElementType,
        title: String = "",
        iconName: String = "",
        x: Double,
        y: Double,
        width: Double = 140,
        height: Double = 48,
        rotation: Double = 0,
        opacity: Double = 1.0,
        locked: Bool = false,
        hidden: Bool = false,
        zIndex: Int = 0,
        targetScreenID: UUID? = nil,
        backgroundColorHex: String? = nil,
        textColorHex: String? = nil
    ) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.iconName = iconName
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.opacity = opacity
        self.locked = locked
        self.hidden = hidden
        self.zIndex = zIndex
        self.targetScreenID = targetScreenID
        self.backgroundColorHex = backgroundColorHex
        self.textColorHex = textColorHex
    }
}


enum ElementType: String, Codable {
    case rectangle
    case circle
    case text
    case image
    case icon
    case button
    case input
}
