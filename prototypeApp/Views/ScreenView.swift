//
//  PageScreenView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI
import SwiftData

struct ScreenView: View {
    var screen: CanvasScreen
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = CanvasViewModel()
    @State private var isDrawing: Bool = false
    
    @State private var showElementMenu: Bool = false
    @State private var menuPosition: CGPoint = CGPoint(x: 200, y: 300)
    
    @State private var selectedElementToLink: CanvasElement?
    @State private var elementToCustomize: CanvasElement?
    @State private var showLinkScreenSheet: Bool = false
    @State private var showPrototypePreview: Bool = false
    
    var projectScreens: [CanvasScreen] {
        screen.project?.screens ?? [screen]
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            // iPhone Device Frame Mockup Editor Container
            editorPhoneMockup
            
            // Dropdown Menu on Long Press
            if showElementMenu {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showElementMenu = false
                        }
                    }
                
                elementDropdownMenu
                    .position(
                        x: min(max(menuPosition.x, 110), UIScreen.main.bounds.width - 110),
                        y: min(max(menuPosition.y, 160), UIScreen.main.bounds.height - 180)
                    )
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .onLongPressGesture(minimumDuration: 0.45) {
            menuPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showElementMenu = true
            }
        }
        .overlay(alignment: .bottom) {
            BottomToolbar(viewModel: viewModel)
                .opacity(isDrawing ? 0.0 : 1.0)
                .offset(y: isDrawing ? 60 : 0)
                .allowsHitTesting(!isDrawing)
                .padding(.bottom, AppSpacing.s)
        }
        .navigationTitle(screen.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(isDrawing ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 12) {
                    // Back Navigation Button
                    Button {
                        viewModel.saveDrawing(to: screen, context: context)
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.bold))
                        }
                        .foregroundStyle(.black)
                    }
                    
                    // Add UI Element Button
                    Button {
                        menuPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
                        withAnimation(.spring(response: 0.3)) {
                            showElementMenu = true
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: AppStrings.plusIcon)
                                .font(.subheadline.weight(.bold))
                        }
                        .foregroundStyle(.black)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        viewModel.saveDrawing(to: screen, context: context)
                        showPrototypePreview = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "play.fill")
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(.green)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupScreen(screen)
        }
        .onDisappear {
            viewModel.saveDrawing(to: screen, context: context)
        }
        .onChange(of: isDrawing) { _, newValue in
            if !newValue {
                viewModel.saveDrawing(to: screen, context: context)
            }
        }
        .navigationDestination(isPresented: $showPrototypePreview) {
            PrototypePreviewView(initialScreen: screen, allScreens: projectScreens)
        }
        .sheet(isPresented: $showLinkScreenSheet) {
            linkScreenSelectionSheet
        }
        .sheet(item: $elementToCustomize) { element in
            ElementCustomizationView(element: element, availableScreens: projectScreens, onDelete: {
                deleteElement(element)
            })
        }
        .animation(.easeInOut(duration: 0.2), value: isDrawing)
        .dismissKeyboardOnTap()
    }
    
    @ViewBuilder
    private var editorPhoneMockup: some View {
        GeometryReader { geometry in
            let baseWidth: CGFloat = 393
            let baseHeight: CGFloat = 852
            
            let maxFrameHeight = min(geometry.size.height * 0.85, 780)
            let maxFrameWidth = min(geometry.size.width * 0.90, maxFrameHeight * (baseWidth / baseHeight))
            
            let scaleWidth = maxFrameWidth / baseWidth
            let scaleHeight = maxFrameHeight / baseHeight
            let scale = min(scaleWidth, scaleHeight)
            
            let displayWidth = baseWidth * scale
            let displayHeight = baseHeight * scale
            
            ZStack {
                // Outer Phone Bezel Frame
                RoundedRectangle(cornerRadius: 50 * scale, style: .continuous)
                    .fill(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50 * scale, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .white.opacity(0.1), .black],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: max(2, 4 * scale)
                            )
                    )
                    .shadow(color: .black.opacity(0.25), radius: 25 * scale, x: 0, y: 12 * scale)
                
                // Screen Content Area
                ZStack {
                    Color(.systemBackground)
                    
                    // 1. Drawing Canvas
                    CanvasContainer(
                        drawing: $viewModel.drawing,
                        tool: $viewModel.currentPKTool,
                        isDrawing: $isDrawing
                    )
                    .allowsHitTesting(viewModel.selectedToolType != .idle)
                    
                    // 2. Predefined Wireframe Canvas Elements
                    ForEach(screen.elements) { element in
                        CanvasElementView(element: element, onDelete: {
                            deleteElement(element)
                        }, onLinkTap: {
                            selectedElementToLink = element
                            showLinkScreenSheet = true
                        }, onCustomizeTap: {
                            elementToCustomize = element
                        })
                    }
                }
                .frame(width: baseWidth, height: baseHeight)
                .scaleEffect(scale)
                .frame(width: displayWidth - (12 * scale), height: displayHeight - (12 * scale))
                .clipShape(RoundedRectangle(cornerRadius: 44 * scale, style: .continuous))
                
                // Phone Hardware Features (Dynamic Island & Home Bar)
                VStack {
                    // Dynamic Island / Notch
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 115 * scale, height: 28 * scale)
                        .padding(.top, 14 * scale)
                    
                    Spacer()
                    
                    // Home Indicator Pill
                    Capsule()
                        .fill(Color.primary.opacity(0.35))
                        .frame(width: 135 * scale, height: 5 * scale)
                        .padding(.bottom, 12 * scale)
                }
                .allowsHitTesting(false)
            }
            .frame(width: displayWidth, height: displayHeight)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 15)
        }
    }
    
    @ViewBuilder
    private var linkScreenSelectionSheet: some View {
        NavigationStack {
            List {
                Section("Link Element To Screen") {
                    Button {
                        if let element = selectedElementToLink {
                            element.targetScreenID = nil
                            try? context.save()
                        }
                        showLinkScreenSheet = false
                    } label: {
                        HStack {
                            Image(systemName: "link.slash")
                                .foregroundStyle(.red)
                            Text("Remove Link")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Section("Available Screens") {
                    ForEach(projectScreens.filter { $0.id != screen.id }) { targetScreen in
                        Button {
                            if let element = selectedElementToLink {
                                element.targetScreenID = targetScreen.id
                                try? context.save()
                            }
                            showLinkScreenSheet = false
                        } label: {
                            HStack {
                                Image(systemName: "iphone")
                                    .foregroundStyle(.secondary)
                                Text(targetScreen.name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if selectedElementToLink?.targetScreenID == targetScreen.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Connect Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showLinkScreenSheet = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    @ViewBuilder
    private var elementDropdownMenu: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ADD UI ELEMENT")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.top, 8)
            
            Divider()
            
            Group {
                menuButton(title: "Button", icon: "square.and.arrow.down.fill", color: .black) {
                    addElement(type: .button, title: "Button", width: 120, height: 44)
                }
                
                menuButton(title: "Text Header", icon: "textformat", color: .black) {
                    addElement(type: .text, title: "Title Header", width: 140, height: 36)
                }
                
                menuButton(title: "Text Input", icon: "rectangle.and.pencil.and.ellipsis", color: .black) {
                    addElement(type: .input, title: "Text input...", width: 180, height: 44)
                }
                
                menuButton(title: "Card", icon: "square.dashed", color: .black) {
                    addElement(type: .rectangle, title: "Card Container", width: 180, height: 120)
                }
                
                menuButton(title: "Avatar", icon: "person.crop.circle.fill", color: .black) {
                    addElement(type: .circle, iconName: "person.fill", width: 64, height: 64)
                }
                
                menuButton(title: "Icon", icon: AppStrings.plusIcon, color: .black) {
                    addElement(type: .icon, iconName: "star.fill", width: 44, height: 44)
                }
                
                menuButton(title: "Image Box", icon: "photo.fill", color: .black) {
                    addElement(type: .image, title: "Image Box", width: 160, height: 100)
                }
            }
        }
        .padding(.vertical, 4)
        .frame(width: 210)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
    
    @ViewBuilder
    private func menuButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button {
            action()
            withAnimation(.easeInOut(duration: 0.2)) {
                showElementMenu = false
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 20)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func addElement(type: ElementType, title: String = "", iconName: String = "", width: Double, height: Double) {
        let element = CanvasElement(
            type: type,
            title: title,
            iconName: iconName,
            x: menuPosition.x,
            y: menuPosition.y,
            width: width,
            height: height
        )
        context.insert(element)
        screen.elements.append(element)
        try? context.save()
    }
    
    private func deleteElement(_ element: CanvasElement) {
        HapticFeedback.heavy()
        withAnimation(.spring(response: 0.3)) {
            if let idx = screen.elements.firstIndex(where: { $0.id == element.id }) {
                screen.elements.remove(at: idx)
            }
            context.delete(element)
            try? context.save()
        }
    }
}
