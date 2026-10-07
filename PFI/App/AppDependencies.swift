//
//  AppDependencies.swift
//  PFI
//
//  Created by Ди Di on 25/09/26.
//

import SwiftData
import SwiftUI

@MainActor
struct AppDependencies {
    let container: ModelContainer
    private static let schema = Schema([
        Topic.self, Subtopic.self, Question.self, CodingTask.self,
        LearningProgress.self, ReviewLog.self, Note.self
    ])

    static func live() throws(AppError) -> AppDependencies {
        do {
            let container = try ModelContainer(for: Self.schema)
            return AppDependencies(container: container)
        } catch {
            throw AppError.storageUnavailable(underlying: error.localizedDescription)
        }
    }

    static func preview() -> AppDependencies {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Self.schema, configurations: config)

            return AppDependencies(container: container)
        } catch {
            preconditionFailure("Не удалось создать контейнер для превью: \(error.localizedDescription)")
        }
    }
}

extension EnvironmentValues {
    @Entry var dependencies: AppDependencies?
}
