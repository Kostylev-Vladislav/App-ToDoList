//
//  ParcingCSV.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation

extension ToDoItem {
    var csv: String {
        let createdDateString = createdDate.timeIntervalSince1970.description
        let deadlineString = deadline?.timeIntervalSince1970.description ?? ""
        let changedDateString = changedDate?.timeIntervalSince1970.description ?? ""
        let colorHexString = String(describing: colorHex)
        return "\(id),\(text),\(importance.rawValue),\(isDone),\(createdDateString),\(deadlineString),\(changedDateString),\(colorHexString)"
    }
    
    static func parse(csv: String) -> ToDoItem? {
        var components = [String]()
        var currentComponent = ""
        var insideQuotes = false

        for char in csv {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }
        components.append(currentComponent)

        guard components.count >= 8,
              let isDone = Bool(components[3]),
              let createdTime = TimeInterval(components[4]) else {
            return nil
        }
        
        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .normal
        let createdDate = Date(timeIntervalSince1970: createdTime)
        
        let deadline = TimeInterval(components[5]).map { Date(timeIntervalSince1970: $0) }
        let changedDate = TimeInterval(components[6]).map { Date(timeIntervalSince1970: $0) }
        
        let colorHex = components[7]
        
        return ToDoItem(
            id: id,
            text: text,
            importance: importance,
            isDone: isDone,
            createdDate: createdDate,
            deadline: deadline,
            changedDate: changedDate,
            colorHex: colorHex
        )
    }
}
