import SwiftUI
import SwiftData

struct ElementCustomizationView: View {
    @Bindable var element: CanvasElement
    let availableScreens: [CanvasScreen]
    var onDelete: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    private let iconOptions = [

        // Navigation
        "house.fill",
        "house",
        "square.grid.2x2.fill",
        "list.bullet",
        "sidebar.left",
        "chevron.left",
        "chevron.right",
        "arrow.left",
        "arrow.right",
        "arrow.up",
        "arrow.down",

        // User
        "person.fill",
        "person.circle.fill",
        "person.2.fill",
        "person.crop.circle",
        "person.badge.plus",

        // Communication
        "phone.fill",
        "message.fill",
        "bubble.left.fill",
        "envelope.fill",
        "paperplane.fill",
        "video.fill",

        // Search
        "magnifyingglass",
        "line.3.horizontal.decrease.circle.fill",

        // Favorites
        "heart.fill",
        "heart",
        "star.fill",
        "star",
        "bookmark.fill",
        "bookmark",

        // Actions
        "plus",
        "plus.circle.fill",
        "minus.circle.fill",
        "pencil",
        "square.and.pencil",
        "trash.fill",
        "trash",
        "square.and.arrow.up",
        "square.and.arrow.down.fill",
        "ellipsis",
        "ellipsis.circle.fill",

        // Settings
        "gearshape.fill",
        "slider.horizontal.3",
        "wrench.and.screwdriver.fill",

        // Security
        "lock.fill",
        "lock.open.fill",
        "key.fill",
        "faceid",
        "touchid",

        // Notifications
        "bell.fill",
        "bell.badge.fill",

        // Shopping
        "cart.fill",
        "bag.fill",
        "creditcard.fill",
        "tag.fill",

        // Media
        "photo.fill",
        "camera.fill",
        "video.fill",
        "play.fill",
        "pause.fill",
        "stop.fill",
        "music.note",

        // Documents
        "doc.fill",
        "doc.text.fill",
        "folder.fill",
        "folder.badge.plus",
        "archivebox.fill",

        // Calendar
        "calendar",
        "calendar.badge.plus",
        "clock.fill",
        "alarm.fill",

        // Maps
        "location.fill",
        "mappin.and.ellipse",
        "map.fill",
        "location.circle.fill",

        // Finance
        "wallet.pass.fill",
        "banknote.fill",
        "dollarsign.circle.fill",
        "chart.bar.fill",
        "chart.line.uptrend.xyaxis",

        // Health
        "cross.case.fill",
        "heart.text.square.fill",
        "figure.walk",
        "figure.run",

        // Devices
        "iphone",
        "ipad",
        "desktopcomputer",
        "applewatch",

        // Status
        "checkmark.circle.fill",
        "checkmark.seal.fill",
        "xmark.circle.fill",
        "exclamationmark.triangle.fill",
        "info.circle.fill",

        // Cloud
        "icloud.fill",
        "cloud.fill",
        "arrow.clockwise.icloud.fill",

        // Misc
        "globe",
        "wifi",
        "antenna.radiowaves.left.and.right",
        "bolt.fill",
        "flame.fill",
        "leaf.fill",
        "gift.fill",
        "trophy.fill",
        "flag.fill",
        "link",
        "scissors",
        "paintbrush.fill",
        "wand.and.stars",
        "sparkles"
    ]
    
    private let bgColors: [(name: String, hex: String)] = [
        ("Default", ""),
        ("Blue", "#007AFF"),
        ("Green", "#34C759"),
        ("Orange", "#FF9500"),
        ("Purple", "#AF52DE"),
        ("Red", "#FF3B30"),
        ("Dark Slate", "#1C1C1E"),
        ("Light Gray", "#E5E5EA"),
        ("White", "#FFFFFF")
    ]
    
    private let textColors: [(name: String, hex: String)] = [
        ("Default", ""),
        ("White", "#FFFFFF"),
        ("Black", "#000000"),
        ("Gray", "#8E8E93"),
        ("Blue", "#007AFF"),
        ("Red", "#FF3B30"),
        ("Green", "#34C759")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                // 0. Lock & Protection Section
                Section("Element Lock & Protection") {
                    Toggle(isOn: $element.locked) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Lock Element Position")
                                Text("Prevents dragging or accidental moves")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: element.locked ? "lock.fill" : "lock.open.fill")
                                .foregroundStyle(element.locked ? .red : .gray)
                        }
                    }
                    .onChange(of: element.locked) { _, _ in
                        HapticFeedback.medium()
                        try? context.save()
                    }
                }
                
                // Predefined Element Size Section
                Section("Predefined Element Size") {
                    Picker("Element Size", selection: Binding(
                        get: {
                            currentSizeCategory(for: element)
                        },
                        set: { newCategory in
                            HapticFeedback.selection()
                            let dims = newCategory.dimensions(for: element.type)
                            element.width = dims.width
                            element.height = dims.height
                            try? context.save()
                        }
                    )) {
                        ForEach(PredefinedElementSize.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text("Target Dimensions")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int(element.width)) × \(Int(element.height)) pt")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary)
                    }
                }
                
                // 1. Text & Label Section (Shown for Button, Text, Input, Card, Image)
                if element.type != .circle && element.type != .icon {
                    Section(textSectionHeader(for: element.type)) {
                        TextField(textPlaceholder(for: element.type), text: $element.title)
                            .autocorrectionDisabled()
                    }
                }
                
                // 2. Icon Picker Section (Shown for Button, Input, Circle, Icon, Image)
                if element.type == .button || element.type == .input || element.type == .circle || element.type == .icon || element.type == .image {
                    Section(iconSectionHeader(for: element.type)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                Button {
                                    HapticFeedback.selection()
                                    element.iconName = ""
                                    try? context.save()
                                } label: {
                                    Text("None")
                                        .font(.caption.weight(.bold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(element.iconName.isEmpty ? Color.black : Color(.systemGray5))
                                        .foregroundStyle(element.iconName.isEmpty ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                                
                                ForEach(iconOptions, id: \.self) { icon in
                                    Button {
                                        HapticFeedback.selection()
                                        element.iconName = icon
                                        try? context.save()
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.title3)
                                            .padding(10)
                                            .background(element.iconName == icon ? Color.black : Color(.systemGray5))
                                            .foregroundStyle(element.iconName == icon ? .white : .primary)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                
                // 3. Color Customization Section
                Section("Color Customization") {
                    // Container / Background Color (Shown for Button, Input, Card, Circle, Image)
                    if element.type != .text && element.type != .icon {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(element.type == .rectangle ? "Card Fill Color" : "Background Color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(bgColors, id: \.hex) { item in
                                        Button {
                                            HapticFeedback.selection()
                                            element.backgroundColorHex = item.hex.isEmpty ? nil : item.hex
                                            try? context.save()
                                        } label: {
                                            Circle()
                                                .fill(colorFromHex(item.hex, fallback: Color(.systemGray5)))
                                                .frame(width: 34, height: 34)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.primary, lineWidth: (element.backgroundColorHex ?? "") == item.hex ? 3 : 1)
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    
                    // Text / Icon / Tint Color (Shown for Button, Text, Input, Circle, Icon, Image)
                    if element.type != .rectangle {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(textColorLabel(for: element.type))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(textColors, id: \.hex) { item in
                                        Button {
                                            HapticFeedback.selection()
                                            element.textColorHex = item.hex.isEmpty ? nil : item.hex
                                            try? context.save()
                                        } label: {
                                            Circle()
                                                .fill(colorFromHex(item.hex, fallback: Color(.systemGray5)))
                                                .frame(width: 34, height: 34)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.primary, lineWidth: (element.textColorHex ?? "") == item.hex ? 3 : 1)
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
                
                // 4. Fine-Tuning Dimensions Section
                Section("Custom Dimensions (Manual Sliders)") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Width")
                            Spacer()
                            Text("\(Int(element.width)) pt")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $element.width, in: 24...360, step: 4) { _ in
                            try? context.save()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Height")
                            Spacer()
                            Text("\(Int(element.height)) pt")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $element.height, in: 24...320, step: 4) { _ in
                            try? context.save()
                        }
                    }
                }
                

                
                // 5. Delete Section
                if let onDelete = onDelete {
                    Section {
                        Button {
                            HapticFeedback.heavy()
                            onDelete()
                            dismiss()
                        } label: {
                            HStack(spacing: 8) {
                                Spacer()
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                                Text("Delete Element")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle(inspectorTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        try? context.save()
                        dismiss()
                    }
                    .font(.body.weight(.bold))
                }
            }
            .dismissKeyboardOnTap()
        }
    }
    
    private var inspectorTitle: String {
        switch element.type {
        case .button: return "Button Settings"
        case .text: return "Header Text Settings"
        case .input: return "Text Input Settings"
        case .rectangle: return "Card Container Settings"
        case .circle: return "Avatar / Circle Settings"
        case .icon: return "Icon Symbol Settings"
        case .image: return "Image Box Settings"
        }
    }
    
    private func textSectionHeader(for type: ElementType) -> String {
        switch type {
        case .button: return "Button Label"
        case .text: return "Header Text Content"
        case .input: return "Input Placeholder Text"
        case .rectangle: return "Card Container Title"
        case .image: return "Image Box Caption"
        default: return "Text Content"
        }
    }
    
    private func textPlaceholder(for type: ElementType) -> String {
        switch type {
        case .button: return "Button Title"
        case .text: return "Header Title"
        case .input: return "Placeholder text..."
        case .rectangle: return "Card Header"
        case .image: return "Image Caption"
        default: return "Text"
        }
    }
    
    private func iconSectionHeader(for type: ElementType) -> String {
        switch type {
        case .button: return "Optional Button Icon"
        case .input: return "Leading Input Icon"
        case .circle: return "Avatar Symbol"
        case .icon: return "Icon Symbol Selection"
        case .image: return "Image Placeholder Symbol"
        default: return "Select Icon"
        }
    }
    
    private func textColorLabel(for type: ElementType) -> String {
        switch type {
        case .text: return "Text Color"
        case .icon: return "Icon Tint Color"
        case .circle: return "Icon Tint Color"
        case .image: return "Image Symbol Tint"
        case .input: return "Text & Icon Color"
        default: return "Text & Icon Color"
        }
    }
    
    private func currentSizeCategory(for element: CanvasElement) -> PredefinedElementSize {
        let small = PredefinedElementSize.small.dimensions(for: element.type)
        let medium = PredefinedElementSize.medium.dimensions(for: element.type)
        let large = PredefinedElementSize.large.dimensions(for: element.type)
        let full = PredefinedElementSize.full.dimensions(for: element.type)
        
        let diffSmall = abs(element.width - small.width) + abs(element.height - small.height)
        let diffMedium = abs(element.width - medium.width) + abs(element.height - medium.height)
        let diffLarge = abs(element.width - large.width) + abs(element.height - large.height)
        let diffFull = abs(element.width - full.width) + abs(element.height - full.height)
        
        let minDiff = min(diffSmall, min(diffMedium, min(diffLarge, diffFull)))
        if minDiff == diffSmall { return .small }
        if minDiff == diffMedium { return .medium }
        if minDiff == diffLarge { return .large }
        return .full
    }
    
    private func colorFromHex(_ hex: String, fallback: Color) -> Color {
        guard !hex.isEmpty else { return fallback }
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return fallback }
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}

enum PredefinedElementSize: String, CaseIterable, Identifiable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case full = "Full Width"
    
    var id: String { rawValue }
    
    func dimensions(for type: ElementType) -> (width: Double, height: Double) {
        switch type {
        case .button:
            switch self {
            case .small: return (90, 36)
            case .medium: return (160, 44)
            case .large: return (240, 52)
            case .full: return (320, 56)
            }
        case .input:
            switch self {
            case .small: return (140, 36)
            case .medium: return (220, 44)
            case .large: return (280, 48)
            case .full: return (320, 52)
            }
        case .rectangle:
            switch self {
            case .small: return (120, 80)
            case .medium: return (200, 130)
            case .large: return (280, 180)
            case .full: return (340, 240)
            }
        case .circle:
            switch self {
            case .small: return (44, 44)
            case .medium: return (64, 64)
            case .large: return (90, 90)
            case .full: return (120, 120)
            }
        case .icon:
            switch self {
            case .small: return (28, 28)
            case .medium: return (40, 40)
            case .large: return (56, 56)
            case .full: return (80, 80)
            }
        case .image:
            switch self {
            case .small: return (120, 120)
            case .medium: return (200, 150)
            case .large: return (280, 160)
            case .full: return (340, 220)
            }
        case .text:
            switch self {
            case .small: return (100, 28)
            case .medium: return (180, 36)
            case .large: return (250, 48)
            case .full: return (320, 60)
            }
        }
    }
}
