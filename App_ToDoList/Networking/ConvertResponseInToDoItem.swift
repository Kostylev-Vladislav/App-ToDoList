//
//  ConvertResponseInToDoItem.swift
//  App_ToDoList
//
//  Created by Владислав on 17.07.2024.
//

import Foundation

func ConvertResponseInToDoItem(from response: ToDoResponse) -> ToDoItem{
    let id = response.id
    let text = response.text
    let importance = response.importance
//    let importance = Importance.basic
    let isDone = response.isDone
    let createdDate = Date(timeIntervalSince1970: Double(response.createdDate))
    
    let deadline: Date?
    if let deadlineTime = response.deadline {
        deadline = Date(timeIntervalSince1970: Double(deadlineTime))
    } else {
        deadline = nil
    }
    let changedDate: Date?
    if let changedDateTime = response.deadline {
        changedDate = Date(timeIntervalSince1970: Double(changedDateTime))
    } else {
        changedDate = nil
    }
    let colorHex = response.colorHex
    let category = TaskCategory.other
    return ToDoItem(id: id, text: text, importance: importance, isDone: isDone, createdDate: createdDate, deadline: deadline, changedDate: changedDate, colorHex: colorHex, category: category)
}
