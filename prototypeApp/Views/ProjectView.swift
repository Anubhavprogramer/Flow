//
//  ProjectView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI
import SwiftData

struct ProjectView : View {
    let project: Project
    
    @State private var showAddScreenScreen: Bool = false
    
    @Query
    private var screens: [CanvasScreen]
    
    init(project: Project) {
        self.project = project
        
        let id = project.id
        
        _screens = Query(
            filter: #Predicate<CanvasScreen> {
                $0.project?.id == id
            },
             sort: \.updatedAt,
             order: .reverse
        )
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(project.desc)
                .font(.subheadline)
                .fontWeight(.regular)
                .padding(.vertical, AppSpacing.s)
                .padding(.horizontal, AppSpacing.m)
            
            List(screens) { screen in
                NavigationLink {
                    ScreenView(screen: screen)
                } label : {
                    VStack{
                        Image(systemName: "Home")
                        Text(screen.name)
                    }
                }
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    showAddScreenScreen = true
                } label: {
                    Image(systemName: AppStrings.plusIcon)
                }
            }
        }
        .sheet(isPresented: $showAddScreenScreen){
            NewScreenView( project: project)
        }
        
    }
}
