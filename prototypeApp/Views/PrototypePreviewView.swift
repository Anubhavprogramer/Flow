import SwiftUI
import SwiftData
import PencilKit

struct PrototypePreviewView: View {
    let initialScreen: CanvasScreen
    let allScreens: [CanvasScreen]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentScreen: CanvasScreen
    @State private var screenHistory: [CanvasScreen] = []
    @State private var showHotspotHint: Bool = false
    @State private var drawing: PKDrawing = PKDrawing()
    @State private var previewTool: PKTool = PKInkingTool(.pen, color: .black, width: 1.0)
    
    init(initialScreen: CanvasScreen, allScreens: [CanvasScreen]) {
        self.initialScreen = initialScreen
        self.allScreens = allScreens
        self._currentScreen = State(initialValue: initialScreen)
    }
    
    var body: some View {
        ZStack {
            // Crisp Pure White Studio Backdrop
            Color.white
                .ignoresSafeArea()
            
            // iPhone Device Frame Mockup
            iPhoneDeviceMockup
        }
        .navigationTitle(currentScreen.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(currentScreen.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Text("PROTOTYPE MODE")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color(white: 0.4))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    if !screenHistory.isEmpty {
                        Button {
                            navigateBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.bold))
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Button {
                        restartPrototype()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.body.weight(.bold))
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .toolbarColorScheme(.light, for: .navigationBar)
        .onAppear {
            loadScreenDrawing()
        }
        .onChange(of: currentScreen.id) { _, _ in
            loadScreenDrawing()
        }
    }
    
    @ViewBuilder
    private var iPhoneDeviceMockup: some View {
        GeometryReader { geometry in
            let baseWidth: CGFloat = 393
            let baseHeight: CGFloat = 852
            
            let maxFrameHeight = min(geometry.size.height * 0.88, 780)
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
                    .shadow(color: .black.opacity(0.6), radius: 30 * scale, x: 0, y: 16 * scale)
                
                // Screen Content Area
                ZStack {
                    Color(.systemGray6)
                    
                    // 1. Drawing Canvas Background (Read-only)
                    CanvasContainer(
                        drawing: $drawing,
                        tool: $previewTool,
                        isDrawing: .constant(false)
                    )
                    .disabled(true)
                    
                    // 2. Interactive Wireframe Elements
                    ForEach(currentScreen.elements) { element in
                        previewElementView(element)
                    }
                    
                    // 3. Hotspot Hint Flash Layer
                    if showHotspotHint {
                        Color.black.opacity(0.01)
                            .onTapGesture {
                                flashHotspots()
                            }
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
                        .fill(Color.primary.opacity(0.45))
                        .frame(width: 135 * scale, height: 5 * scale)
                        .padding(.bottom, 12 * scale)
                }
                .allowsHitTesting(false)
            }
            .frame(width: displayWidth, height: displayHeight)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    @ViewBuilder
    private func previewElementView(_ element: CanvasElement) -> some View {
        let isLinked = element.targetScreenID != nil
        let customBgColor = colorFromHex(element.backgroundColorHex ?? "")
        let customTextColor = colorFromHex(element.textColorHex ?? "")
        
        Group {
            switch element.type {
            case .button:
                HStack(spacing: 8) {
                    if !element.iconName.isEmpty {
                        Image(systemName: element.iconName)
                    }
                    Text(element.title.isEmpty ? "Button" : element.title)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundStyle(customTextColor ?? .white)
                .frame(width: max(element.width, 80), height: max(element.height, 36))
                .background(customBgColor ?? Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                
            case .input:
                HStack {
                    Image(systemName: element.iconName.isEmpty ? "magnifyingglass" : element.iconName)
                        .foregroundStyle(customTextColor ?? .secondary)
                    Text(element.title.isEmpty ? "Text input..." : element.title)
                        .foregroundStyle(customTextColor ?? .secondary)
                    Spacer()
                }
                .font(.subheadline)
                .padding(.horizontal, 12)
                .frame(width: max(element.width, 120), height: max(element.height, 36))
                .background(customBgColor ?? Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                
            case .text:
                Text(element.title.isEmpty ? "Header Text" : element.title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(customTextColor ?? .primary)
                    .padding(6)
                    .background(customBgColor ?? .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
            case .rectangle:
                RoundedRectangle(cornerRadius: 12)
                    .fill(customBgColor ?? Color(.systemBackground).opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
                    )
                    .overlay(
                        Text(element.title.isEmpty ? "Card Container" : element.title)
                            .font(.caption)
                            .foregroundStyle(customTextColor ?? .secondary)
                    )
                    .frame(width: max(element.width, 100), height: max(element.height, 60))
                    
            case .circle:
                Circle()
                    .fill(customBgColor ?? Color(.systemBackground).opacity(0.85))
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
                    )
                    .overlay(
                        Image(systemName: element.iconName.isEmpty ? "person.fill" : element.iconName)
                            .font(.title2)
                            .foregroundStyle(customTextColor ?? .secondary)
                    )
                    .frame(width: max(element.width, 44), height: max(element.width, 44))
                    
            case .icon:
                Image(systemName: element.iconName.isEmpty ? "star.fill" : element.iconName)
                    .font(.system(size: max(element.height * 0.7, 24)))
                    .foregroundStyle(customTextColor ?? Color.accentColor)
                    .padding(8)
                    .background(customBgColor ?? .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
            case .image:
                ZStack {
                    Rectangle()
                        .fill(customBgColor ?? Color.gray.opacity(0.15))
                        .overlay(
                            Rectangle()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    VStack(spacing: 4) {
                        Image(systemName: element.iconName.isEmpty ? "photo" : element.iconName)
                            .font(.title2)
                            .foregroundStyle(customTextColor ?? .secondary)
                        Text(element.title.isEmpty ? "Image Placeholder" : element.title)
                            .font(.caption2)
                            .foregroundStyle(customTextColor ?? .secondary)
                    }
                }
                .frame(width: max(element.width, 100), height: max(element.height, 70))
            }
        }
        .overlay(
            Group {
                if showHotspotHint && isLinked {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                        .shadow(color: .blue.opacity(0.8), radius: 6)
                }
            }
        )
        .position(x: element.x, y: element.y)
        .onTapGesture {
            if let targetID = element.targetScreenID,
               let targetScreen = allScreens.first(where: { $0.id == targetID }) {
                navigateTo(targetScreen)
            } else {
                flashHotspots()
            }
        }
    }
    
    private func loadScreenDrawing() {
        self.drawing = currentScreen.drawing
    }
    
    private func navigateTo(_ targetScreen: CanvasScreen) {
        HapticFeedback.success()
        screenHistory.append(currentScreen)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            currentScreen = targetScreen
        }
    }
    
    private func navigateBack() {
        guard let previous = screenHistory.popLast() else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            currentScreen = previous
        }
    }
    
    private func restartPrototype() {
        screenHistory.removeAll()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            currentScreen = initialScreen
        }
    }
    
    private func flashHotspots() {
        withAnimation(.easeIn(duration: 0.15)) {
            showHotspotHint = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.25)) {
                showHotspotHint = false
            }
        }
    }
    
    private func colorFromHex(_ hex: String) -> Color? {
        guard !hex.isEmpty else { return nil }
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}
