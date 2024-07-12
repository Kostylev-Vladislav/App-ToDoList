//
//  FileCache.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation

enum FileCacheError: Error {
    case fileNotFound
    case invalidData
    case saveError
    case loadError
}

class FileCache {
    private(set) var tasks: [ToDoItem] = [ToDoItem(text: "Пример задачи 1", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "F12B30", category: .hobby), ToDoItem(text: "Пример задачи 2", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 1000000), changedDate: nil, colorHex: "5FFF30", category: .work), ToDoItem(text: "Пример задачи 3", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B50"), ToDoItem(text: "Пример задачи 4", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "953B30"), ToDoItem(text: "Пример задачи 5", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 6", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "F03B00"), ToDoItem(text: "Пример задачи 7", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 8", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "0F3B30"), ToDoItem(text: "Пример задачи", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF9B30"), ToDoItem(text: "Пример задачи 9", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 10", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 11", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 12", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 13", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 14", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "BF3B30"), ToDoItem(text: "Пример задачи 15", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 16", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 17", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B00"), ToDoItem(text: "Пример задачи", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 18", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 19", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30", category: .work), ToDoItem(text: "Пример задачи 20", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "FF3030")]
    
    func add(task: ToDoItem) {
        let itemDuplicated = tasks.contains { $0.id == task.id }
        if !itemDuplicated {
            tasks.append(task)
        }
    }
    
    func update(updatedTask: ToDoItem) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
    
    func remove(id: String) {
        tasks.removeAll {$0.id == id}
    }
    
    func save(filename: String) throws {
        let jsonArray = tasks.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let fileURL = URL(filePath: filename)
            try jsonData.write(to: fileURL)
        } catch {
            throw FileCacheError.saveError
        }
    }
        
    func load(filename: String) throws {
        let fileURL = URL(filePath: filename)
        do {
            let jsonData = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
                tasks = jsonArray.compactMap { ToDoItem.parse(json: $0) }
            } else {
                throw FileCacheError.invalidData
            }
        } catch {
            throw FileCacheError.loadError
        }
    }
}
