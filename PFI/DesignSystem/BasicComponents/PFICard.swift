//
//  PFICard.swift
//  PFI
//
//  Created by Ди Di on 05/08/26.
//

import SwiftUI

struct PFICard<Content: View>: View {
    private let content: Content
    private let shape = RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.sp16)
            .background(Color(.pfiSurface), in: shape)
            .overlay {
                shape.strokeBorder(Color(.pfiSeparator), lineWidth: 1)
            }
    }
}

#Preview("Светлая") {
    PFICard {
        VStack(alignment: .leading, spacing: Spacing.sp8) {
            Text("Тема 1")
                .font(.pfiHeadline)
                .foregroundStyle(Color(.pfiTextPrimary))
            Text("48 вопросов · 30 изучено")
                .font(.pfiCaption)
                .foregroundStyle(Color(.pfiTextSecondary))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(Spacing.sp16)
    .frame(maxHeight: .infinity)
    .background(Color(.pfiBackground))
}

#Preview("Тёмная") {
    PFICard {
        VStack(alignment: .leading, spacing: Spacing.sp8) {
            Text("Тема 1")
                .font(.pfiHeadline)
                .foregroundStyle(Color(.pfiTextPrimary))
            Text("48 вопросов · 30 изучено")
                .font(.pfiCaption)
                .foregroundStyle(Color(.pfiTextSecondary))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(Spacing.sp16)
    .frame(maxHeight: .infinity)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
