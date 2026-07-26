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
    
    @Environment(\.modelContext) private var context
    @State private var showAddScreenScreen: Bool = false
    @State private var showPrototypePreview: Bool = false
    @State private var previewStartScreen: CanvasScreen?
    
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
            
            List {
                ForEach(screens) { screen in
                    NavigationLink {
                        ScreenView(screen: screen)
                    } label: {
                        HStack(spacing: AppSpacing.m) {
                            Image(systemName: "iphone")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(screen.name)
                                    .font(.headline)
                                
                                HStack(spacing: 8) {
                                    Text("Updated \(screen.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                                    
                                    if screenHasLinks(screen) {
                                        HStack(spacing: 3) {
                                            Image(systemName: "link")
                                            Text("\(linkedCount(for: screen)) links")
                                        }
                                        .font(.caption2.weight(.medium))
                                        .foregroundStyle(Color.accentColor)
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(screens[index])
                    }
                    try? context.save()
                }
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    if let firstScreen = screens.first {
                        Button {
                            previewStartScreen = firstScreen
                            showPrototypePreview = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "play.fill")
                                Text("Play")
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                        }
                    }
                    
                    Button {
                        showAddScreenScreen = true
                    } label: {
                        Image(systemName: AppStrings.plusIcon)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddScreenScreen){
            NewScreenView(project: project)
        }
        .navigationDestination(isPresented: $showPrototypePreview) {
            if let startScreen = previewStartScreen ?? screens.first {
                PrototypePreviewView(initialScreen: startScreen, allScreens: screens)
            }
        }
    }
    
    private func screenHasLinks(_ screen: CanvasScreen) -> Bool {
        screen.elements.contains { $0.targetScreenID != nil }
    }
    
    private func linkedCount(for screen: CanvasScreen) -> Int {
        screen.elements.filter { $0.targetScreenID != nil }.count
    }
}
