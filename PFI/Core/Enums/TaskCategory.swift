//
//  TaskCategory.swift
//  PFI
//
//  Created by Ди Di on 24/09/26.
//

enum TaskCategory: String, Codable, Sendable, CaseIterable {
    case algorithms          // поиск, сортировки, два указателя, сложность
    case dataStructures      // массивы, словари, множества, деревья, графы
    case swiftLanguage       // опционалы, дженерики, протоколы, value vs reference
    case concurrency         // async/await, акторы, Sendable, гонки
    case memory              // ARC, retain-циклы, weak/unowned, утечки
    case uikit               // жизненный цикл контроллера, ячейки, Auto Layout
    case swiftui             // стейт, перерисовки, жизненный цикл вью
}
