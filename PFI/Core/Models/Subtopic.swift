//
//  Subtopic.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class Subtopic {
    var id: UUID = UUID()
    var title: String = ""
    var order: Int = 0
    var topic: Topic?
    @Relationship(deleteRule: .cascade, inverse: \Question.subtopic)
    var questions: [Question] = []

    init(id: UUID = UUID(), title: String = "", order: Int = 0, topic: Topic? = nil, questions: [Question] = []) {
        self.id = id
        self.title = title
        self.order = order
        self.topic = topic
        self.questions = questions
    }
}
