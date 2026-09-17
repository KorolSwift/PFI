//
//  PFIButtonStyle.swift
//  PFI
//
//  Created by Ди Di on 05/08/26.
//

import SwiftUI

struct PFIButtonStyle: ButtonStyle {
    enum Variant {
        case primary,
             secondary,
             ghost
    }
    let variant: Variant

    func makeBody(configuration: Configuration) -> some View {
        StyleBody(configuration: configuration, variant: variant)
    }

    private struct StyleBody: View {
        let configuration: Configuration
        let variant: Variant
        private let shape = RoundedRectangle(cornerRadius: Radius.r12, style: .continuous)
        private var pressedScale: CGFloat {
            guard configuration.isPressed else { return 1 }
            return reduceMotion ? 1 : 0.98
        }

        private var currentOpacity: Double {
            if !isEnabled { return 0.4 }
            if configuration.isPressed && reduceMotion { return 0.85 }
            return 1
        }

        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        private var backgroundColor: Color {
            switch variant {
            case .primary:
                    .pfiAccent
            case .secondary:
                    .pfiAccent.opacity(0.12)
            case .ghost:
                    .clear
            }
        }

        private var foreground: Color {
            switch variant {
            case .primary:
                    .pfiTextOnAccent
            case .secondary:
                    .pfiAccent
            case .ghost:
                    .pfiAccent
            }
        }

        private var shapeColor: Color {
            switch variant {
            case .primary:
                    .clear
            case .secondary:
                    .pfiAccent.opacity(0.3)
            case .ghost:
                    .clear

            }
        }

        var body: some View {
            configuration.label
                .padding(.vertical, 13) // значение отсутствует в Spacing
                .padding(.horizontal, Spacing.sp20)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(backgroundColor, in: shape)
                .font(.pfiBody)
                .foregroundStyle(foreground)
                .multilineTextAlignment(.center)
                .overlay {
                    shape.strokeBorder(shapeColor, lineWidth: 1)
                }
                .opacity(currentOpacity)
                .scaleEffect(pressedScale)
                .contentShape(shape)
                .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
        }
    }
}

extension ButtonStyle where Self == PFIButtonStyle {
    static var pfiPrimary: PFIButtonStyle { PFIButtonStyle(variant: .primary) }
    static var pfiSecondary: PFIButtonStyle { PFIButtonStyle(variant: .secondary) }
    static var pfiGhost: PFIButtonStyle { PFIButtonStyle(variant: .ghost) }
}

#Preview("Светлая") {
    VStack {
        Button("Начать сессию") { }
            .buttonStyle(.pfiPrimary)

        Button("Добавить заметку") { }
            .buttonStyle(.pfiSecondary)

        Button("Показать решение") { }
            .buttonStyle(.pfiGhost)

        Button("НажатьНажатьНажатьНажатьНажатьНажатьНажатьНажать") { }
            .buttonStyle(.pfiPrimary)
            .disabled(true)
    }
    .padding(Spacing.sp16)
    .frame(maxHeight: .infinity)
    .background(Color(.pfiBackground))
}

#Preview("Тёмная") {
    VStack {
        Button("Начать сессию") { }
            .buttonStyle(.pfiPrimary)

        Button("Добавить заметку") { }
            .buttonStyle(.pfiSecondary)

        Button("Показать решение") { }
            .buttonStyle(.pfiGhost)

        Button("Нажать") { }
            .buttonStyle(.pfiPrimary)
            .disabled(true)
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: 300, maxHeight: .infinity)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
