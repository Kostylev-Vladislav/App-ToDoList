//
//  FileCache.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation
import SwiftUI

enum FileCacheError: Error {
    case fileNotFound
    case invalidData
    case saveError
    case loadError
}

class FileCache {
    private(set) var tasks: [ToDoItem] = []
    
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
    
//    private let userDefaults = UserDefaults.standard
//    private let todosKey = "todos"
    
    func updateAll(_ newTasks: [ToDoItem]) {
        tasks = newTasks
    }
    
//    func saveTodos(_ todos: [ToDoItem]) {
//        if let data = try? JSONEncoder().encode(todos) {
//            userDefaults.set(data, forKey: todosKey)
//            tasks = data
//        }
//    }
//    
//    func loadTodos() -> [ToDoItem] {
//        if let data = userDefaults.data(forKey: todosKey),
//           let todos = try? JSONDecoder().decode([ToDoItem].self, from: data) {
//            return todos
//        }
//        return []
//    }
    
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
