//
//  AppError.swift
//  PFI
//
//  Created by Ди Di on 25/09/26.
//

import Foundation

enum AppError: LocalizedError, Sendable {
    case storageUnavailable(underlying: String)

    var errorDescription: String? {
        switch self {
        case .storageUnavailable:
            "Не удалось открыть хранилище"
        }
    }

    var failureReason: String? {
        switch self {
        case .storageUnavailable(let underlying):
            underlying
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .storageUnavailable:
            "Перезапустите приложение. Если не поможет — переустановите его."
        }
    }
}
