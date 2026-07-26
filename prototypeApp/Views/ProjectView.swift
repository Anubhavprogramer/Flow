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
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private var screens: [CanvasScreen] {
        project.screens.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    private var totalLinksCount: Int {
        screens.reduce(0) { count, screen in
            count + screen.elements.filter { $0.targetScreenID != nil }.count
        }
    }
    
    var body: some View {
        ZStack {
            // Crisp Pure White Canvas Background
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Hero Project Banner Card (Pitch Black Studio)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.name)
                                    .font(.title2.weight(.bold))
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                
                                Text(project.desc.isEmpty ? "Interactive App Wireframe Project" : project.desc)
                                    .font(.subheadline)
                                    .foregroundStyle(Color(white: 0.7))
                            }
                            Spacer()
                            
                            // Play Prototype Pill Button (Crisp White on Pitch Black)
                            if let firstScreen = screens.first {
                                Button {
                                    previewStartScreen = firstScreen
                                    showPrototypePreview = true
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "play.fill")
                                            .font(.caption.weight(.bold))
                                        Text("Play")
                                            .font(.subheadline.weight(.bold))
                                    }
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        
                        // Board Meta Chips
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "iphone")
                                    .foregroundStyle(.white)
                                Text("\(screens.count) Screens")
                                    .foregroundStyle(Color(white: 0.9))
                            }
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(white: 0.18))
                            .clipShape(Capsule())
                            
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                    .foregroundStyle(.white)
                                Text("\(totalLinksCount) Links")
                                    .foregroundStyle(Color(white: 0.9))
                            }
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(white: 0.18))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(18)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // 2. Pitch Black Screen Cards Grid
                    if screens.isEmpty {
                        emptyScreensView
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Canvas Screens")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.black)
                                Spacer()
                                Text("Tap card to edit")
                                    .font(.caption)
                                    .foregroundStyle(Color(white: 0.4))
                            }
                            .padding(.horizontal, 16)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(screens) { screen in
                                    NavigationLink {
                                        ScreenView(screen: screen)
                                    } label: {
                                        screenCard(screen)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 80)
                        }
                    }
                }
            }
            
            // 3. Pitch Black Floating Action Button (Add Screen)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddScreenScreen = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.subheadline.weight(.bold))
                            Text("Add Screen")
                                .font(.subheadline.weight(.bold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .sheet(isPresented: $showAddScreenScreen) {
            NewScreenView(project: project)
        }
        .navigationDestination(isPresented: $showPrototypePreview) {
            if let startScreen = previewStartScreen ?? screens.first {
                PrototypePreviewView(initialScreen: startScreen, allScreens: screens)
            }
        }
    }
    
    // Pitch Black Screen Card Component
    @ViewBuilder
    private func screenCard(_ screen: CanvasScreen) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Screen Mockup Frame Preview
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(white: 0.18))
                    .frame(height: 140)
                
                // iPhone Mockup Silhouette
                VStack {
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 32, height: 6)
                        .padding(.top, 8)
                    Spacer()
                    Image(systemName: "hand.draw.fill")
                        .font(.title2)
                        .foregroundStyle(Color(white: 0.5))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Link Badge
                if screenHasLinks(screen) {
                    HStack(spacing: 3) {
                        Image(systemName: "link")
                        Text("\(linkedCount(for: screen))")
                    }
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding(8)
                }
            }
            
            // Screen Title & Meta Info
            VStack(alignment: .leading, spacing: 4) {
                Text(screen.name)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text("\(screen.elements.count) elements")
                    Text("•")
                    Text(screen.updatedAt.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.caption2)
                .foregroundStyle(Color(white: 0.6))
                .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
        .contextMenu {
            Button(role: .destructive) {
                context.delete(screen)
                try? context.save()
            } label: {
                Label {
                    Text("Delete Screen")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    // Monochrome Empty Screens Placeholder
    @ViewBuilder
    private var emptyScreensView: some View {
        VStack(spacing: 16) {
            Image(systemName: "iphone.badge.play")
                .font(.system(size: 40))
                .foregroundStyle(Color.black)
                .padding(.top, 20)
            
            VStack(spacing: 4) {
                Text("No Screens Added Yet")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
                Text("Add your first wireframe screen to start sketching.")
                    .font(.caption)
                    .foregroundStyle(Color(white: 0.4))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(white: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.12), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
    
    private func screenHasLinks(_ screen: CanvasScreen) -> Bool {
        screen.elements.contains { $0.targetScreenID != nil }
    }
    
    private func linkedCount(for screen: CanvasScreen) -> Int {
        screen.elements.filter { $0.targetScreenID != nil }.count
    }
}
