//
//  ReviewLog.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class ReviewLog {
    var id: UUID = UUID()
    var date: Date = Date.now
    var grade: SelfGrade = SelfGrade.unsure
    var source: ReviewSource = ReviewSource.reading
    var responseSeconds: Double?

    init(id: UUID = UUID(), date: Date = Date.now, grade: SelfGrade = SelfGrade.unsure,
         source: ReviewSource = ReviewSource.reading, responseSeconds: Double? = nil) {
        self.id = id
        self.date = date
        self.grade = grade
        self.source = source
        self.responseSeconds = responseSeconds
    }
}
