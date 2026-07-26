//
//  HomeViewModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import Foundation
import SwiftData
import Combine

final class HomeViewModel: ObservableObject {
    func deleteProject( _ project: Project, context: ModelContext) {
        context.delete(project)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
