//
//  NewProjectView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI
import SwiftData

struct NewProjectView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = NewProjectViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Project Name"){
                    TextField("Project Name", text: $viewModel.projectName)
                }
                
                Section("Project Description"){
                    TextField("Project Description", text: $viewModel.projectDescription)
                }
            }
            .navigationTitle("Create a Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.createProject(context: context)
                        dismiss()
                    } label: {
                        Image(systemName: AppStrings.doneButton)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: AppStrings.backButton)
                    }
                }
            }
        }
    }
}

