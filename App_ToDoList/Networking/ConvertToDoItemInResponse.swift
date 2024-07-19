//
//  ConvertToDoItemInResponse.swift
//  App_ToDoList
//
//  Created by Владислав on 18.07.2024.
//

import Foundation
import UIKit

func ConvertToDoItemInResponse(from item: ToDoItem) -> ToDoResponse{
    let id = item.id
    let text = item.text
    let importance = item.importance
    let isDone = item.isDone
    let createdDate = Int64(item.createdDate.timeIntervalSince1970)
    
    let deadlineTime: Int64?
    if let deadline = item.deadline {
        deadlineTime = Int64(deadline.timeIntervalSince1970)
    } else {
        deadlineTime = nil
    }
    let changedDateTime: Int64
    if let changedDate = item.changedDate {
        changedDateTime = Int64(changedDate.timeIntervalSince1970)
    } else {
        changedDateTime = Int64(item.createdDate.timeIntervalSince1970)
    }

    let colorHex = item.colorHex
    let last_updated_by = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
//    let files: [String] = []

    return ToDoResponse(id: id, text: text, importance: importance, deadline: deadlineTime, isDone: isDone, colorHex: nil, createdDate: createdDate, changedDate: changedDateTime, last_updated_by: last_updated_by, files: nil)
}
