//
//  ParcingJson.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation

extension ToDoItem {
    enum JSONKeys: String {
        case id
        case text
        case isDone
        case createdDate
        case importance
        case deadline
        case changedDate
        case colorHex
    }

    var json: Any {
        var dict: [String: Any] = [
            JSONKeys.id.rawValue: id,
            JSONKeys.text.rawValue: text,
            JSONKeys.isDone.rawValue: isDone,
            JSONKeys.createdDate.rawValue: createdDate.timeIntervalSince1970
        ]
        if importance != .normal {
            dict[JSONKeys.importance.rawValue] = importance.rawValue
        }
        if let deadline = deadline {
            dict[JSONKeys.deadline.rawValue] = deadline.timeIntervalSince1970
        }
        if let changedDate = changedDate {
            dict[JSONKeys.changedDate.rawValue] = changedDate.timeIntervalSince1970
        }
        if let colorHex = colorHex {
            dict[JSONKeys.colorHex.rawValue] = colorHex
        }
        return dict
    }
    
    static func parse(json: Any) -> ToDoItem? {
        guard let dict = json as? [String: Any] else { return nil }
        
        guard let id = dict[JSONKeys.id.rawValue] as? String,
              let text = dict[JSONKeys.text.rawValue] as? String,
              let isDone = dict[JSONKeys.isDone.rawValue] as? Bool,
              let createdTime = dict[JSONKeys.createdDate.rawValue] as? TimeInterval else { return nil }
        
        let importanceRawValue = dict[JSONKeys.importance.rawValue] as? String
        let importance = Importance(rawValue: importanceRawValue ?? Importance.normal.rawValue) ?? .normal
        
        let createdDate = Date(timeIntervalSince1970: createdTime)
        
        let deadlineTime = dict[JSONKeys.deadline.rawValue] as? TimeInterval
        let changedTime = dict[JSONKeys.changedDate.rawValue] as? TimeInterval
        
        let deadline = deadlineTime.map { Date(timeIntervalSince1970: $0) }
        let changedDate = changedTime.map { Date(timeIntervalSince1970: $0) }
        
        let colorHex = dict[JSONKeys.colorHex.rawValue] as? String
        
        return ToDoItem(id: id, text: text, importance: importance, isDone: isDone, createdDate: createdDate, deadline: deadline, changedDate: changedDate, colorHex: colorHex)
    }
}
