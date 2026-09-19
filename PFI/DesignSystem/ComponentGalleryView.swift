//
//  ComponentGalleryView.swift
//  PFI
//
//  Created by Ди Di on 19/09/26.
//

import SwiftUI

#if DEBUG
struct ComponentGalleryView: View {
    @State private var scheme: ColorScheme?
    @State private var size: DynamicTypeSize = .large
    @State private var isSelected = false

    @ViewBuilder
    private var chips: some View {
        Button("Тема 1") { isSelected.toggle() }
            .buttonStyle(.topicChip(isSelected: isSelected))
        Button("Тема 2") { }
            .buttonStyle(.topicChip(isSelected: true))
        Button("Тема 3") { }
            .buttonStyle(.topicChip(isSelected: false))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Spacing.sp24) {
                Picker("Тема", selection: $scheme) {
                    Text("Системная").tag(ColorScheme?.none)
                    Text("Светлая").tag(ColorScheme?.some(.light))
                    Text("Тёмная").tag(ColorScheme?.some(.dark))
                }
                .pickerStyle(.segmented)

                Picker("Шрифт", selection: $size) {
                    Text("XS").tag(DynamicTypeSize.xSmall)
                    Text("L").tag(DynamicTypeSize.large)
                    Text("XXXL").tag(DynamicTypeSize.xxxLarge)
                    Text("A1").tag(DynamicTypeSize.accessibility1)
                    Text("A3").tag(DynamicTypeSize.accessibility3)
                }
                .pickerStyle(.segmented)

                GallerySection(title: "EmptyStateView") {
                    EmptyStateView(
                        variant: .withoutResult
                    )
                    .frame(maxWidth: .infinity)
                    EmptyStateView(
                        variant: .nothingToRepeat,
                        action: .init(title: "Выбрать тему") { }
                    )
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "PFIButton") {
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

                GallerySection(title: "PFICard") {
                    PFICard {
                        Text("Тема 1")
                            .font(.pfiHeadline)
                            .foregroundStyle(Color(.pfiTextPrimary))
                        Text("48 вопросов · 30 изучено")
                            .font(.pfiCaption)
                            .foregroundStyle(Color(.pfiTextSecondary))
                    }
                }

                GallerySection(title: "PFITopicChip") {
                    ViewThatFits {
                        HStack(spacing: Spacing.sp8) {
                            chips
                        }
                        VStack(spacing: Spacing.sp8) {
                            chips
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "ProgressRing") {
                    HStack(spacing: Spacing.sp8) {
                        ForEach([0, 0.25, 0.75, 1.0], id: \.self) { ProgressRing(value: $0) }
                    }
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "StatusBadge") {
                    BadgeGallery()
                }
            }
            .padding(Spacing.sp16)
        }
        .background(Color(.pfiBackground))
        .preferredColorScheme(scheme)
        .dynamicTypeSize(size)
    }
}

private struct GallerySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sp12) {
            Text(title)
                .font(.pfiCaption)
                .foregroundStyle(.pfiTextSecondary)
                .textCase(.uppercase)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct BadgeGallery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sp16) {
            Text("Без заливки")
                .font(.pfiCaption)
                .foregroundStyle(Color(.pfiTextSecondary))
            ViewThatFits {
                HStack(spacing: Spacing.sp8) {
                    ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0) }
                }
                VStack(alignment: .leading, spacing: Spacing.sp8) {
                    ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0) }
                }
            }

            Text("С заливкой")
                .font(.pfiCaption)
                .foregroundStyle(Color(.pfiTextSecondary))
            ViewThatFits {
                HStack(spacing: Spacing.sp8) {
                    ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0, filled: true) }
                }
                VStack(alignment: .leading, spacing: Spacing.sp8) {
                    ForEach(StatusBadge.Variant.allCases, id: \.self) { StatusBadge(variant: $0, filled: true) }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
#endif
