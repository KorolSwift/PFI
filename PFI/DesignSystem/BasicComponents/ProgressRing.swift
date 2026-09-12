//
//  ProgressRing.swift
//  PFI
//
//  Created by Ди Di on 19/08/26.
//

import SwiftUI

struct ProgressRing: View {
    let value: Double
    @State private var currentProgress: Double = 0.0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var fillAnimation: Animation? {
        reduceMotion ? nil : .easeOut(duration: 0.45)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.pfiSeparator, style: StrokeStyle(lineWidth: 5, lineCap: .round))
            Circle()
                .trim(from: 0.0, to: currentProgress)
                .stroke(.pfiAccent, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
        }
        .modifier(PercentLabel(value: currentProgress))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Прогресс по теме")
        .accessibilityValue("\(Int((value * 100).rounded()))%")
        .frame(width: 56, height: 56)  // отсутствует в Radius
        .onAppear {
            withAnimation(fillAnimation) {
                currentProgress = value
            }
        }
        .onChange(of: value) { _, newValue in
            withAnimation(fillAnimation) {
                currentProgress = newValue
            }
        }
    }
}

private struct PercentLabel: ViewModifier, Animatable {
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        content.overlay {
            Text("\(Int((value * 100).rounded()))")
                .font(.pfiCode.weight(.semibold))
                .foregroundStyle(.pfiTextPrimary)
        }
    }
}

#Preview("Светлая") {
    HStack(spacing: Spacing.sp8) {
        ForEach([0, 0.25, 0.75, 1.0], id: \.self) { ProgressRing(value: $0) }
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color(.pfiBackground))
}

#Preview("Тёмная") {
    HStack(spacing: Spacing.sp8) {
        ForEach([0, 0.25, 0.75, 1.0], id: \.self) { ProgressRing(value: $0) }
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
