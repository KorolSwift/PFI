//
//  EmptyStateView.swift
//  PFI
//
//  Created by Ди Di on 12/09/26.
//

import SwiftUI

struct EmptyStateView: View {
    struct Action {
        let title: String
        let handler: () -> Void
    }

    enum Variant {
        case withoutResult,
             noNotes,
             nothingToRepeat
    }

    private var symbolName: String {
        switch variant {
        case .withoutResult: "magnifyingglass"
        case .noNotes: "square.and.pencil"
        case .nothingToRepeat: "checkmark"
        }
    }

    private var title: String {
        switch variant {
        case .withoutResult: "Ничего не найдено"
        case .noNotes: "Пока нет заметок"
        case .nothingToRepeat: "На сегодня всё"
        }
    }

    private var description: String {
        switch variant {
        case .withoutResult: "Попробуйте изменить запрос или сбросить фильтры"
        case .noNotes: "Добавьте свой вариант ответа или пометку"
        case .nothingToRepeat: "Возвращайтесь завтра или начните новую тему"
        }
    }

    let variant: Variant
    var action: Action?
    @ScaledMetric(relativeTo: .caption)
    private var subtitleMaxWidth: CGFloat = 240 // по спецификации 30ch, что примерно 220–240 pt

    var body: some View {
        VStack(spacing: Spacing.sp8) {
            ZStack {
                Circle()
                    .fill(Color(.pfiTextSecondary).opacity(0.12))
                    .frame(width: 46, height: 46)  // отсутствует в Radius
                Image(systemName: symbolName) // символ внутри круга фикс-го размера не должен расти с Dynamic Type
                    .font(.system(size: 22))
                    .foregroundStyle(Color(.pfiTextSecondary))
                    .accessibilityHidden(true)
            }
            .padding(.bottom, Spacing.sp4)
            Text(title)
                .font(.pfiHeadline)
                .foregroundStyle(.pfiTextPrimary)
            Text(description)
                .frame(maxWidth: subtitleMaxWidth)
                .font(.pfiCaption)
                .foregroundStyle(.pfiTextSecondary)
            if let action {
                Button(action.title, action: action.handler)
                    .buttonStyle(.pfiSecondary)
                    .padding(.top, Spacing.sp8)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, Spacing.sp32)
        .padding(.horizontal, Spacing.sp20)
    }
}

#Preview("Светлая") {
    VStack {
        EmptyStateView(
            variant: .withoutResult
        )

        EmptyStateView(
            variant: .nothingToRepeat,
            action: .init(title: "Выбрать тему") { }
        )
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.pfiBackground))
}

#Preview("Темная") {
    VStack {
        EmptyStateView(
            variant: .withoutResult,
            action: nil
        )

        EmptyStateView(
            variant: .nothingToRepeat,
            action: .init(title: "Выбрать тему") { }
        )
    }
    .padding(Spacing.sp16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.pfiBackground))
    .preferredColorScheme(.dark)
}
