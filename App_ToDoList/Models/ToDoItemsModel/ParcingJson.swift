//
//  ParcingJson.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation
import UIKit



extension ToDoItem {
    enum JSONKeys: String, CodingKey {
        case id
        case text
        case importance
        case isDone = "done"
        case colorHex = "color"
        case createdDate = "created_at"
        case changedDate = "changed_at"
        case deadline
        case last_updated_by
        case files
    }

    var json: Any {
        var dict: [String: Any] = [
            JSONKeys.id.rawValue: id,
            JSONKeys.text.rawValue: text,
            JSONKeys.isDone.rawValue: isDone,
            JSONKeys.importance.rawValue: importance.rawValue,
            JSONKeys.createdDate.rawValue: Int64(createdDate.timeIntervalSince1970),
            JSONKeys.changedDate.rawValue: Int64(createdDate.timeIntervalSince1970),
            JSONKeys.last_updated_by.rawValue: UIDevice.current.identifierForVendor?.uuidString ?? "unknow"
        ]

        if let deadline = deadline {
            dict[JSONKeys.deadline.rawValue] = Int64(deadline.timeIntervalSince1970)
        }
        if let changedDate = changedDate {
            dict[JSONKeys.changedDate.rawValue] = Int64(changedDate.timeIntervalSince1970)
        } else {
            dict[JSONKeys.changedDate.rawValue] = Int64(createdDate.timeIntervalSince1970)
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
        
//        let categoryRawValue = dict[JSONKeys.category.rawValue] as? String
//        let category = TaskCategory(rawValue: categoryRawValue ?? TaskCategory.other.rawValue) ?? .other
        
        let importanceRawValue = dict[JSONKeys.importance.rawValue] as? String
        let importance = Importance(rawValue: importanceRawValue ?? Importance.basic.rawValue) ?? .basic
        
        let createdDate = Date(timeIntervalSince1970: createdTime)
        
        let deadlineTime = dict[JSONKeys.deadline.rawValue] as? TimeInterval
        let changedTime = dict[JSONKeys.changedDate.rawValue] as? TimeInterval
        
        let deadline = deadlineTime.map { Date(timeIntervalSince1970: $0) }
        let changedDate = changedTime.map { Date(timeIntervalSince1970: $0) }
        
        let colorHex = dict[JSONKeys.colorHex.rawValue] as? String
        
        return ToDoItem(id: id, text: text, importance: importance, isDone: isDone, createdDate: createdDate, deadline: deadline, changedDate: changedDate, colorHex: colorHex, category: .other)
    }
    
    enum ParsingError: Error {
        case invalidFormat
        case missingField(String)
    }
    
    static func parseTodoList(from jsonData: Data) throws -> [ToDoItem] {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let dict = jsonObject as? [String: Any],
                  let list = dict["list"] as? [[String: Any]] else {
                throw ParsingError.invalidFormat
            }
            return list.compactMap {ToDoItem.parse(json: $0)}
        } catch {
            throw error
        }
    }
}
