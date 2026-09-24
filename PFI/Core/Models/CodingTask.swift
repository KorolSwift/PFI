//
//  CodingTask.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class CodingTask {
    var id: UUID = UUID()
    var title: String = ""
    var statementMarkdown: String = ""
    var difficulty: Difficulty = Difficulty.easy
    var category: TaskCategory = TaskCategory.algorithms
    var hints: [String] = []                // прогрессивные подсказки
    var referenceSolution: String = ""
    var mySolution: String = ""
    var solvedIndependently: Bool = false
    @Relationship(deleteRule: .cascade) var progress: LearningProgress?
    @Relationship(deleteRule: .cascade) var notes: [Note] = []

    init(id: UUID = UUID(), title: String = "", statementMarkdown: String = "",
         difficulty: Difficulty = Difficulty.easy, category: TaskCategory = TaskCategory.algorithms,
         hints: [String] = [], referenceSolution: String = "", mySolution: String = "",
         solvedIndependently: Bool = false, progress: LearningProgress? = nil, notes: [Note] = []) {
        self.id = id
        self.title = title
        self.statementMarkdown = statementMarkdown
        self.difficulty = difficulty
        self.category = category
        self.hints = hints
        self.referenceSolution = referenceSolution
        self.mySolution = mySolution
        self.solvedIndependently = solvedIndependently
        self.progress = progress
        self.notes = notes
    }
}
