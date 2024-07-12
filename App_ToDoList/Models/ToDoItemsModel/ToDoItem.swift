//
//  ToDoItem.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation

struct ToDoItem {
    let id: String
    var text: String
    var importance: Importance
    var isDone: Bool
    let createdDate: Date
    var deadline: Date?
    var changedDate: Date?
    var colorHex: String?
    var category: TaskCategory
    
    init(id: String = UUID().uuidString, text: String, importance: Importance = .normal,isDone: Bool = false, createdDate: Date = Date(), deadline: Date? = nil, changedDate: Date? = nil, colorHex: String? = nil, category: TaskCategory = .other) {
        self.id = id
        self.text = text
        self.importance = importance
        self.isDone = isDone
        self.createdDate = createdDate
        self.deadline = deadline
        self.changedDate = changedDate
        self.colorHex = colorHex
        self.category = category
    }
}
