//
//  FileCacheTests.swift
//  App_ToDoListTests
//
//  Created by Владислав on 24.06.2024.
//

import XCTest
@testable import App_ToDoList


class FileCacheTests: XCTestCase {
    
    func testAddItem() {
        let cache = FileCache()
        let item = ToDoItem(text: "Test")
        
        cache.add(task: item)
        
        XCTAssertEqual(cache.tasks.count, 1)
        XCTAssertEqual(cache.tasks.first?.id, item.id)
    }
    
    func testRemoveItem() {
        let cache = FileCache()
        let item = ToDoItem(text: "Test")
        
        cache.add(task: item)
        cache.remove(id: item.id)
        
        XCTAssertTrue(cache.tasks.isEmpty)
    }
    
    func testSaveLoad() {
        let cache = FileCache()
        let item = ToDoItem(text: "Test")
        cache.add(task: item)
        
        // Временный файл для тестирования
        let filename = FileManager.default.temporaryDirectory.appendingPathComponent("testfile.json").path
        
        do {
            try cache.save(filename: filename)
        } catch {
            
        }
        
        let newCache = FileCache()
        
        do {
            try newCache.load(filename: filename)
        } catch {

        }
        
        
        XCTAssertEqual(newCache.tasks.count, 1)
        XCTAssertEqual(newCache.tasks.first?.id, item.id)
        
        // Удаление временного файла
        if FileManager.default.fileExists(atPath: filename) {
            try? FileManager.default.removeItem(atPath: filename)
        }
    }
}
