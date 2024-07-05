//
//  CheckDeadline.swift
//  App_ToDoList
//
//  Created by Владислав on 02.07.2024.
//

import Foundation

func checkDeadine(date: Date?) -> Date? {
    let calendar = Calendar.current
    
    guard let deadline = date else { return nil }
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: deadline)
    return calendar.date(from: dateComponents)
}

func getUniqueDays(from tasks: [ToDoItem]) -> [Date] {

    let uniqueDates = Set(tasks.compactMap { task -> Date? in
        checkDeadine(date: task.deadline)
    })
    return uniqueDates.sorted()
}


