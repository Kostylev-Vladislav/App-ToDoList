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
    
    func save(filename: String) throws {
        let jsonArray = items.map { $0.json }
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
                items = jsonArray.compactMap { ToDoItem.parse(json: $0) }
            } else {
                throw FileCacheError.invalidData
            }
        } catch {
            throw FileCacheError.loadError
        }
    }
}
