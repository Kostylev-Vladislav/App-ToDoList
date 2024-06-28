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
        
        cache.add(item: item)
        
        XCTAssertEqual(cache.items.count, 1)
        XCTAssertEqual(cache.items.first?.id, item.id)
    }
    
    func testRemoveItem() {
        let cache = FileCache()
        let item = ToDoItem(text: "Test")
        
        cache.add(item: item)
        cache.remove(id: item.id)
        
        XCTAssertTrue(cache.items.isEmpty)
    }
    
    func testSaveLoad() {
        let cache = FileCache()
        let item = ToDoItem(text: "Test")
        cache.add(item: item)
        
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
        
        
        XCTAssertEqual(newCache.items.count, 1)
        XCTAssertEqual(newCache.items.first?.id, item.id)
        
        // Удаление временного файла
        if FileManager.default.fileExists(atPath: filename) {
            try? FileManager.default.removeItem(atPath: filename)
        }
    }
}
