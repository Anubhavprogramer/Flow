//
//  NewProjectView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI

struct NewProjectView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var projectName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Add a new Project here")
                
                Section("Project details"){
                    TextField("Project Name", text: $projectName)
                }
            }
            .navigationTitle("Create a Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
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
