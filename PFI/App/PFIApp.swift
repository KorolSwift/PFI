//
//  PFIApp.swift
//  PFI
//
//  Created by Ди Di on 01/08/26.
//

import SwiftUI

@main
struct PFIApp: App {
    private let dependencies: Result<AppDependencies, Error>

    init() {
        dependencies = Result {
            try AppDependencies.live()
        }
    }

    var body: some Scene {
        WindowGroup {
            switch dependencies {
            case .success(let deps):
                ComponentGalleryView()
                    .environment(\.dependencies, deps)
            case .failure(let error):
                StorageErrorView(
                    error: error as? AppError
                    ?? .storageUnavailable(underlying: error.localizedDescription)
                )
            }
        }
    }
}
