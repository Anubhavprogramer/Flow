import SwiftUI
import SwiftData

struct CanvasElementView: View {
    @Environment(\.modelContext) private var context
    @Bindable var element: CanvasElement
    var onDelete: () -> Void
    var onLinkTap: (() -> Void)? = nil
    var onCustomizeTap: (() -> Void)? = nil
    
    @State private var dragOffset: CGSize = .zero
    @State private var isSelected: Bool = false
    @State private var isResizing: Bool = false
    @State private var initialSize: CGSize? = nil
    
    private var customBgColor: Color? {
        guard let hex = element.backgroundColorHex, !hex.isEmpty else { return nil }
        return colorFromHex(hex)
    }
    
    private var customTextColor: Color? {
        guard let hex = element.textColorHex, !hex.isEmpty else { return nil }
        return colorFromHex(hex)
    }
    
    var body: some View {
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
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
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
                if element.locked {
                    Image(systemName: "lock.fill")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                        .position(x: 8, y: 8)
                } else if element.targetScreenID != nil && !isSelected {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.black, Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        .position(x: 10, y: 10)
                }
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(element.locked ? Color.red : Color.black, lineWidth: 1.5)
                        .overlay(alignment: .topLeading) {
                            Button {
                                HapticFeedback.medium()
                                onCustomizeTap?()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 32, height: 32)
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1.5)
                                        )
                                    
                                    Image(systemName: "gearshape.fill")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .buttonStyle(.plain)
                            .offset(x: -12, y: -12)
                            .highPriorityGesture(
                                TapGesture().onEnded {
                                    HapticFeedback.medium()
                                    onCustomizeTap?()
                                }
                            )
                        }
                        .overlay(alignment: .topTrailing) {
                            if !element.locked {
                                Button {
                                    HapticFeedback.medium()
                                    onLinkTap?()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(element.targetScreenID != nil ? Color.black : Color.white)
                                            .frame(width: 32, height: 32)
                                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1.5)
                                            )
                                        
                                        Image(systemName: element.targetScreenID != nil ? "link.circle.fill" : "link")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(element.targetScreenID != nil ? Color.white : Color.black)
                                    }
                                }
                                .buttonStyle(.plain)
                                .offset(x: 12, y: -12)
                                .highPriorityGesture(
                                    TapGesture().onEnded {
                                        HapticFeedback.medium()
                                        onLinkTap?()
                                    }
                                )
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            if !element.locked && (element.type == .rectangle || element.type == .image) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 34, height: 34)
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                    
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.white)
                                }
                                .offset(x: 12, y: 12)
                                .contentShape(Circle())
                                .highPriorityGesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            isResizing = true
                                            let startSize = initialSize ?? CGSize(width: element.width, height: element.height)
                                            if initialSize == nil {
                                                initialSize = startSize
                                            }
                                            element.width = max(startSize.width + value.translation.width, 60)
                                            element.height = max(startSize.height + value.translation.height, 40)
                                        }
                                        .onEnded { _ in
                                            isResizing = false
                                            initialSize = nil
                                            try? context.save()
                                        }
                                )
                            }
                        }
                }
            }
        )
        .frame(minWidth: max(element.width, 44), minHeight: max(element.height, 44))
        .contentShape(Rectangle())
        .position(x: element.x + dragOffset.width, y: element.y + dragOffset.height)
        .onTapGesture {
            HapticFeedback.light()
            withAnimation(.spring(response: 0.2)) {
                isSelected.toggle()
            }
        }
        .onLongPressGesture(minimumDuration: 0.35) {
            HapticFeedback.medium()
            withAnimation(.spring(response: 0.3)) {
                isSelected = true
                onCustomizeTap?()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !element.locked && !isResizing {
                        if dragOffset == .zero {
                            HapticFeedback.selection()
                        }
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    if !element.locked && !isResizing {
                        element.x += value.translation.width
                        element.y += value.translation.height
                        dragOffset = .zero
                    }
                }
        )
    }
    
    private func colorFromHex(_ hex: String) -> Color? {
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
