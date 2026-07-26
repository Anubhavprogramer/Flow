//
//  NewScreenViewModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//
import Combine
import SwiftData
import Foundation

final class NewScreenViewModel: ObservableObject{
    
    @Published var ScreenName: String = ""
    
    var isValid: Bool {
        !ScreenName.isEmpty
    }
    
    func createNewScreen(in project: Project, context: ModelContext){
        
        guard isValid else { return }
        
        let screen = CanvasScreen(name: ScreenName)
        screen.project = project
        
        context.insert(screen)
        
        project.updatedAt = .now
        
        do {
            try context.save()
            
            ScreenName = ""
        } catch {
            print(error.localizedDescription)
        }
    }
}
