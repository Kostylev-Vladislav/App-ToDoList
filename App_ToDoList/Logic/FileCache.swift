//
//  FileCache.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import Foundation

final class FileCache {
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
