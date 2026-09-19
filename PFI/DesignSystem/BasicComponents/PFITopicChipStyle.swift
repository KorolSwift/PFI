//
//  PFITopicChipStyle.swift
//  PFI
//
//  Created by Ди Di on 11/08/26.
//

import SwiftUI

struct PFITopicChipStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        StyleBody(configuration: configuration, isSelected: isSelected)
    }

    private struct StyleBody: View {
        private let shape = Capsule()
        let configuration: Configuration
        let isSelected: Bool

        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        private var scaleAmount: CGFloat {
            if configuration.isPressed && !reduceMotion { return 0.96 }
            return 1
        }

        private var pressedOpacity: Double {
            if configuration.isPressed && reduceMotion { return 0.7 }
            return 1
        }

        var body: some View {
            configuration.label
                .padding(.horizontal, 14) // значение отсутствует в Spacing
                .padding(.vertical, 7) // значение отсутствует в Spacing
                .font(.pfiCaption.weight(isSelected ? .medium : .regular))
                .background(isSelected ? .pfiAccent.opacity(0.12) : .pfiSurface, in: shape)
                .foregroundStyle(isSelected ? .pfiAccent : .pfiTextSecondary)
                .overlay {
                    shape.strokeBorder(isSelected ? .pfiAccent : .pfiSeparator, lineWidth: 1)
                }
                .opacity(pressedOpacity)
                .scaleEffect(scaleAmount)
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
                .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

extension ButtonStyle where Self == PFITopicChipStyle {
    static func topicChip(isSelected: Bool) -> PFITopicChipStyle {
        PFITopicChipStyle(isSelected: isSelected)
    }
}

#Preview("Светлая") {
    @Previewable @State var isSelected = false
    VStack {
        Button("Тема 1") {
            isSelected.toggle()
        }
        .buttonStyle(.topicChip(isSelected: isSelected))

        Button("Тема 2") {}
        .buttonStyle(.topicChip(isSelected: true))

        Button("Тема 3") {}
        .buttonStyle(.topicChip(isSelected: false))
    }
    .padding(Spacing.sp16)
    .frame(maxHeight: .infinity)
    .background(Color(.pfiBackground))
}

#Preview("Тёмная") {
    @Previewable @State var isSelected = false
    VStack {
        Button("Тема 1") {
            isSelected.toggle()
        }
        .buttonStyle(.topicChip(isSelected: isSelected))

        Button("Тема 2") {}
        .buttonStyle(.topicChip(isSelected: true))

        Button("Тема 3") {}
        .buttonStyle(.topicChip(isSelected: false))
    }
    .padding(Spacing.sp16)
    .frame(maxHeight: .infinity)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
