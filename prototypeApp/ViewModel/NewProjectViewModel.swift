//
//  NewProjectViewModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftData
import Foundation
import Combine

@MainActor
final class NewProjectViewModel: ObservableObject {
    @Published var projectName = ""
    @Published var projectDescription = ""
    
    var isValidName: Bool {
        !projectName
            .isEmpty
    }
    
    var isValidDescription: Bool {
        !projectDescription
            .isEmpty
    }
    
    func createProject(context: ModelContext) {
        guard isValidName && isValidDescription else {
            return
        }
        
        let project = Project(name: projectName, desc: projectDescription)
        
        context.insert(project)
        
        do {
            try context.save()
            projectName = ""
            projectDescription = ""
            
            print("Data saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
