//
//  Topic.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class Topic {
    var id: UUID = UUID()
    var title: String = ""
    var slug: String = ""
    var order: Int = 0
    var iconName: String = "" // SF Symbol
    @Relationship(deleteRule: .cascade, inverse: \Subtopic.topic)
    var subtopics: [Subtopic] = []

    init(id: UUID = UUID(), title: String = "", slug: String = "",
         order: Int = 0, iconName: String = "") {
        self.id = id
        self.title = title
        self.slug = slug
        self.order = order
        self.iconName = iconName
    }
}
