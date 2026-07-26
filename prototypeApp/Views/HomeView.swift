//
//  HomeView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var showNewProjectSheet = false
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Project.updatedAt, order: .reverse)
    private var projects: [Project]
    
    @StateObject private var viewModel = HomeViewModel()
    
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(projects) { project in
                    Text(project.name)
                        .font(Font.body.weight(.semibold))
                }
                .onDelete { indexSet in
                
                    for index in indexSet {
                        viewModel.deleteProject(projects[index], context: context)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(AppStrings.appName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewProjectSheet = true
                    } label: {
                        Image(systemName: AppStrings.plusIcon)
                            .font(.title3.weight(.semibold))
                    }
                }
            }
            .sheet(isPresented: $showNewProjectSheet) {
                NewProjectView()
            }
        }
        
    }
    
}
