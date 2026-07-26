//
//  HomeView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var appState: AppStats
    @State private var showNewProjectSheet = false
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Project.updatedAt, order: .reverse)
    private var projects: [Project]
    
    @StateObject private var viewModel = HomeViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Crisp Pure White Canvas Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Top Header Bar (Flow on Left, Plus on Right - Always Anchored Top)
                    customHeaderBar
                    
                    if projects.isEmpty {
                        emptyCanvasView
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                // Studio Header Stats
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("My Wireframe Boards")
                                            .font(.title2.weight(.bold))
                                            .fontDesign(.rounded)
                                            .foregroundStyle(.black)
                                        Text("\(projects.count) Projects • Monochrome Canvas")
                                            .font(.caption)
                                            .foregroundStyle(Color(white: 0.4))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                                
                                // Pinterest Grid Layout
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(projects) { project in
                                        NavigationLink {
                                            ProjectView(project: project)
                                        } label: {
                                            projectCard(project)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showNewProjectSheet) {
                NewProjectView()
            }
        }
    }
    
    // Custom Top Header Bar (Flow on Top Left, Plus on Top Right)
    @ViewBuilder
    private var customHeaderBar: some View {
        HStack(alignment: .center) {
            // Top-Left Brand Title
            Text(AppStrings.appName)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
            
            Spacer()
            
            // Top-Right Plus Button
            Button {
                showNewProjectSheet = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: AppStrings.plusIcon)
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.black)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    // Pitch Black & Shades of Black Card Component
    @ViewBuilder
    private func projectCard(_ project: Project) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Visual Card Preview Banner
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(white: 0.18))
                    .frame(height: 90)
                
                // Screen Count Pill Badge
                HStack(spacing: 4) {
                    Image(systemName: "iphone")
                    Text("\(project.screens.count)")
                }
                .font(.caption2.weight(.bold))
                .foregroundStyle(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(8)
                
                // Center Icon Mockup
                Image(systemName: "square.grid.2x2.fill")
                    .font(.title2)
                    .foregroundStyle(Color(white: 0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Text Details
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(project.desc.isEmpty ? "No description added" : project.desc)
                    .font(.caption)
                    .foregroundStyle(Color(white: 0.7))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            HStack {
                Text(project.updatedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(Color(white: 0.5))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color(white: 0.5))
            }
        }
        .padding(14)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .contextMenu {
            Button(role: .destructive) {
                viewModel.deleteProject(project, context: context)
            } label: {
                Label {
                    Text("Delete Board")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    // Monochrome Empty Canvas Graphic
    @ViewBuilder
    private var emptyCanvasView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 100, height: 100)
                
                Image(systemName: AppStrings.squareGrid)
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 6) {
                Text("No Wireframe Boards Yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.black)
                Text("Tap below to create your first black & white prototype board.")
                    .font(.subheadline)
                    .foregroundStyle(Color(white: 0.4))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button {
                showNewProjectSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: AppStrings.plusIcon)
                    Text("Create First Board")
                }
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(Color.black)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
}
