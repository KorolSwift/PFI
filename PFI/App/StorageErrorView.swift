//
//  StorageErrorView.swift
//  PFI
//
//  Created by Ди Di on 25/09/26.
//

import SwiftUI

struct StorageErrorView: View {
    let error: AppError

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.sp16) {
                Image(systemName: "externaldrive.badge.xmark")
                    .font(.pfiTitle)
                Text(error.localizedDescription)
                    .font(.pfiHeadline)
                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.pfiBody)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical, alignment: .center)
            .padding()
        }
    }
}

#Preview("Хранилище недоступно") {
    StorageErrorView(error: AppError.storageUnavailable(underlying: "Файл базы повреждён"))
}
