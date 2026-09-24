//
//  Note.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

import Foundation
import SwiftData

@Model final class Note {
    var id: UUID = UUID()
    var kind: NoteKind = NoteKind.note
    var text: String = ""
    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now

    init(id: UUID = UUID(), kind: NoteKind = NoteKind.note, text: String = "",
         createdAt: Date = Date.now, updatedAt: Date = Date.now) {
        self.id = id
        self.kind = kind
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
