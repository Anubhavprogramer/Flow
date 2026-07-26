import SwiftUI
import SwiftData

struct ElementCustomizationView: View {
    @Bindable var element: CanvasElement
    let availableScreens: [CanvasScreen]
    var onDelete: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    private let iconOptions = [
        "square.and.arrow.down.fill", "star.fill", "heart.fill", "gearshape.fill",
        "person.fill", "envelope.fill", "phone.fill", "lock.fill",
        "paperplane.fill", "trash.fill", "magnifyingglass", "photo.fill",
        "cart.fill", "bell.fill", "house.fill", "checkmark.circle.fill"
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
                        try? context.save()
                    }
                }
                
                // 1. Text / Label Section
                Section("Element Label & Icon") {
                    TextField("Title / Text", text: $element.title)
                        .autocorrectionDisabled()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Icon")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                Button {
                                    element.iconName = ""
                                    try? context.save()
                                } label: {
                                    Text("None")
                                        .font(.caption.weight(.bold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(element.iconName.isEmpty ? Color.accentColor : Color(.systemGray5))
                                        .foregroundStyle(element.iconName.isEmpty ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                
                                ForEach(iconOptions, id: \.self) { icon in
                                    Button {
                                        element.iconName = icon
                                        try? context.save()
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.title3)
                                            .padding(8)
                                            .background(element.iconName == icon ? Color.accentColor : Color(.systemGray5))
                                            .foregroundStyle(element.iconName == icon ? .white : .primary)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // 2. Color Customization Section
                Section("Color Customization") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Background Color")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(bgColors, id: \.hex) { item in
                                    Button {
                                        element.backgroundColorHex = item.hex.isEmpty ? nil : item.hex
                                        try? context.save()
                                    } label: {
                                        Circle()
                                            .fill(colorFromHex(item.hex, fallback: Color(.systemGray5)))
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.primary.opacity(0.3), lineWidth: (element.backgroundColorHex ?? "") == item.hex ? 3 : 1)
                                            )
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text / Icon Color")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(textColors, id: \.hex) { item in
                                    Button {
                                        element.textColorHex = item.hex.isEmpty ? nil : item.hex
                                        try? context.save()
                                    } label: {
                                        Circle()
                                            .fill(colorFromHex(item.hex, fallback: Color(.systemGray5)))
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.primary.opacity(0.3), lineWidth: (element.textColorHex ?? "") == item.hex ? 3 : 1)
                                            )
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // 3. Resizing Section
                Section("Element Dimensions") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Width")
                            Spacer()
                            Text("\(Int(element.width)) pt")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $element.width, in: 40...360, step: 4) { _ in
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
                
                // 4. Navigation Link Target
                if !availableScreens.isEmpty {
                    Section("Interactive Navigation Link") {
                        Picker("Target Screen", selection: $element.targetScreenID) {
                            Text("None (No Link)").tag(UUID?.none)
                            ForEach(availableScreens) { screen in
                                Text(screen.name).tag(UUID?.some(screen.id))
                            }
                        }
                    }
                }
                
                // 5. Delete Section
                if let onDelete = onDelete {
                    Section {
                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            HStack(spacing: 8) {
                                Spacer()
                                Image(systemName: "trash.fill")
                                Text("Delete Element")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Customize Element")
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
        }
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
