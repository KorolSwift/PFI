//
//  LearningProgress.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class LearningProgress {
    var id: UUID = UUID()
    var status: LearningStatus = LearningStatus.new
    var isFlagged: Bool = false             // «повторить перед собесом»
    var firstViewedAt: Date?
    var lastReviewedAt: Date?
    // алгоритм интервальных повторений SM-2 (SuperMemo 2)
    var easeFactor: Double = 2.5            // минимум 1.3
    var intervalDays: Int = 0
    var repetitions: Int = 0
    var dueDate: Date?
    @Relationship(deleteRule: .cascade) var reviews: [ReviewLog] = []

    init(id: UUID = UUID(), status: LearningStatus = LearningStatus.new, isFlagged: Bool = false,
         firstViewedAt: Date? = nil, lastReviewedAt: Date? = nil, easeFactor: Double = 2.5,
         intervalDays: Int = 0, repetitions: Int = 0, dueDate: Date? = nil, reviews: [ReviewLog] = []) {
        self.id = id
        self.status = status
        self.isFlagged = isFlagged
        self.firstViewedAt = firstViewedAt
        self.lastReviewedAt = lastReviewedAt
        self.easeFactor = easeFactor
        self.intervalDays = intervalDays
        self.repetitions = repetitions
        self.dueDate = dueDate
        self.reviews = reviews
    }
}
