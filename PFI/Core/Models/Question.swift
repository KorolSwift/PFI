//
//  Question.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class Question {
    var id: UUID = UUID()
    var text: String = ""
    var answerMarkdown: String = ""
    var level: Level = Level.junior
    var tags: [String] = []
    var order: Int = 0
    var subtopic: Subtopic?
    @Relationship(deleteRule: .cascade) var progress: LearningProgress?   // 1:1
    @Relationship(deleteRule: .cascade) var notes: [Note] = []

    init(id: UUID = UUID(), text: String = "", answerMarkdown: String = "", level: Level = Level.junior,
         tags: [String] = [], order: Int = 0, subtopic: Subtopic? = nil,
         progress: LearningProgress? = nil, notes: [Note] = []) {
        self.id = id
        self.text = text
        self.answerMarkdown = answerMarkdown
        self.level = level
        self.tags = tags
        self.order = order
        self.subtopic = subtopic
        self.progress = progress
        self.notes = notes
    }
}
