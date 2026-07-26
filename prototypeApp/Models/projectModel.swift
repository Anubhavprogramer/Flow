//
//  projectModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import Foundation
import SwiftData

@Model
final class Project {
    
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    
    var desc: String
    
    var createdAt: Date
    
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \CanvasScreen.project)
    var screens: [CanvasScreen] = []
    
    init(name: String, desc: String) {
        self.id = UUID()
        self.name = name
        self.desc = desc
        self.createdAt = .now
        self.updatedAt = .now
        self.screens = []
    }
}
