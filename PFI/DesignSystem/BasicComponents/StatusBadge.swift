//
//  StatusBadge.swift
//  PFI
//
//  Created by Ди Di on 16/08/26.
//

import SwiftUI

struct StatusBadge<Content: View>: View {
    enum Variant: String, CaseIterable {
        case new = "Новый"
        case viewed = "Открыт"
        case learning = "Учу"
        case mastered = "Знаю"
    }

    let filled: Bool
    private let content: Content
    private let shape = RoundedRectangle(cornerRadius: Radius.r8)
    let variant: Variant

    init(variant: Variant = .new, filled: Bool = false, @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.filled = filled
        self.content = content()
    }

    private var foreground: Color {
        switch variant {
        case .viewed:
                .viewed
        case .new:
                .new
        case .mastered:
                .mastered
        case .learning:
                .learning
        }
    }

    private var backgroundColor: Color { foreground.opacity(0.12) }

    private var borderColor: Color { foreground.opacity(0.32) }

    private var symbolName: String {
        switch variant {
        case .new: "circle"
        case .viewed: "circle.lefthalf.filled"
        case .learning: "circle.dotted"
        case .mastered: "checkmark.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 6) { // отсутствует в Spacing
            Image(systemName: symbolName)
                .imageScale(.small)
            content
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.vertical, Spacing.sp4)
        .padding(.horizontal, Spacing.sp8)
        .background(filled ? backgroundColor : .clear, in: shape)
        .font(.pfiCaption.weight(.medium))
        .foregroundStyle(foreground)
        .overlay {
            shape.strokeBorder(filled ? borderColor : .clear, lineWidth: 1)
        }
        .animation(.snappy(duration: 0.2), value: variant)
    }
}

extension StatusBadge where Content == Text {
    init(variant: Variant, filled: Bool = false) {
        self.variant = variant
        self.filled = filled
        self.content = Text(variant.rawValue)
    }
}

#Preview("Светлая") {
    HStack(spacing: Spacing.sp8) {
        ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0) }
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.pfiBackground))
}

#Preview("Тёмная") {
    HStack(spacing: Spacing.sp8) {
        ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0, filled: true) }
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
