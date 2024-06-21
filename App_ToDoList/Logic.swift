//
//  Logic.swift
//  App_ToDoList
//
//  Created by Владислав on 21.06.2024.
//

import Foundation

enum Importance: String {
    case unimportant = "неважная"
    case normal = "обычная"
    case important = "важная"
}

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let isDone: Bool
    let createdDate: Date
    let deadline: Date?
    let changedDate: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance = .normal,isDone: Bool = false, createdDate: Date = Date(), deadline: Date? = nil, changedDate: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.isDone = isDone
        self.createdDate = createdDate
        self.deadline = deadline
        self.changedDate = changedDate
    }
}

extension ToDoItem {
    var json: Any {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "createdDate": createdDate.timeIntervalSince1970
        ]
        if importance != .normal {
            dict["importance"] = importance.rawValue
        }
        if deadline != nil {
            dict["deadline"] = deadline?.timeIntervalSince1970
        }
        if changedDate != nil {
            dict["changedDate"] = changedDate?.timeIntervalSince1970
        }
        return dict
    }
    
    static func parse(json: Any ) -> ToDoItem? {
        guard let dict = json as? [String:Any] else { return nil }
        
        guard let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["isDone"] as? Bool,
              let createdTime = dict["createdDate"] as? TimeInterval else { return nil}
        
        let importanceRawValue = dict["importance"] as? String
        let importance = Importance(rawValue: importanceRawValue ?? Importance.normal.rawValue) ?? .normal
        
        let createdDate = Date(timeIntervalSince1970: createdTime)
        
        let deadlineTime = dict["deadline"] as? TimeInterval
        let changedTime = dict["changedDate"] as? TimeInterval
        
        let deadline = deadlineTime.map { Date(timeIntervalSince1970: $0) }
        let changedDate = changedTime.map { Date(timeIntervalSince1970: $0) }
        
        return ToDoItem(id: id, text: text, importance: importance, isDone: isDone, createdDate: createdDate, deadline: deadline, changedDate: changedDate)
    }
}

class FileCache {
    private(set) var items: [ToDoItem] = []
    
    func add(item: ToDoItem) {
        let itemDuplicated = items.contains { $0.id == item.id }
        if !itemDuplicated {
            items.append(item)
        }
    }
    
    func remove(id: String) {
        items.removeAll {$0.id == id}
    }
    
    private func getFileURL(for filename: String) -> URL {
        //URL(fileURLWithPath:) будет признан устаревшим на новых версиях, проверяем доступность версии и используем соответсвующий функционал
        if #available(iOS 16, *) {
            return URL(filePath: filename)
        } else {
            return URL(fileURLWithPath: filename)
        }
    }
    
    func save(filename: String) {
        let jsonArray = items.map {$0.json}
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted) {
            let fileURL = getFileURL(for: filename)
            try? jsonData.write(to: fileURL)
        }
    }
    
    func load(filename: String) {
        let fileURL = getFileURL(for: filename)
        if let jsonData = try? Data(contentsOf: fileURL), let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
            items = jsonArray.compactMap { ToDoItem.parse(json: $0) }
        }
    }
}

extension ToDoItem {
    var csv: String {
        let createdDateString = createdDate.timeIntervalSince1970.description
        let deadlineString = deadline?.timeIntervalSince1970.description ?? ""
        let changedDateString = changedDate?.timeIntervalSince1970.description ?? ""
        return "\(id),\(text),\(importance.rawValue),\(isDone),\(createdDateString),\(deadlineString),\(changedDateString)"
    }
    
    static func parse(csv: String) -> ToDoItem? {
            let components = csv.components(separatedBy: ",")
            guard components.count >= 7,
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
            
            return ToDoItem(
                id: id,
                text: text,
                importance: importance,
                isDone: isDone,
                createdDate: createdDate,
                deadline: deadline,
                changedDate: changedDate
            )
        }
}
