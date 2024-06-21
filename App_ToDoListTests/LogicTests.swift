//
//  LogicTests.swift
//  App_ToDoListTests
//
//  Created by Владислав on 21.06.2024.
//

import XCTest
@testable import App_ToDoList

class ToDoItemTests: XCTestCase {
    
    func testInitialization() {
        let item = ToDoItem(text: "Test", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil)
        
        XCTAssertEqual(item.text, "Test")
        XCTAssertEqual(item.importance, .important)
        XCTAssertNil(item.deadline)
        XCTAssertFalse(item.isDone)
    }
    
    func testJSONSerialization() {
        let now = Date()
        let item = ToDoItem(id: "1", text: "Test", importance: .important, isDone: false, createdDate: now, deadline: now, changedDate: now)
        let json = item.json as? [String: Any]
        
        XCTAssertEqual(json?["id"] as? String, "1")
        XCTAssertEqual(json?["text"] as? String, "Test")
        XCTAssertEqual(json?["importance"] as? String, "важная")
        XCTAssertEqual(json?["isDone"] as? Bool, false)
        XCTAssertEqual(json?["createdDate"] as? TimeInterval, now.timeIntervalSince1970)
        XCTAssertEqual(json?["deadline"] as? TimeInterval, now.timeIntervalSince1970)
        XCTAssertEqual(json?["changedDate"] as? TimeInterval, now.timeIntervalSince1970)
    }
    
    func testJSONDeserialization() {
        let now = Date()
        let json: [String: Any] = [
            "id": "1",
            "text": "Test",
            "importance": "важная",
            "isDone": false,
            "createdDate": now.timeIntervalSince1970,
            "deadline": now.timeIntervalSince1970,
            "changedDate": now.timeIntervalSince1970
        ]
        
        let item = ToDoItem.parse(json: json)
        
        XCTAssertEqual(item?.id, "1")
        XCTAssertEqual(item?.text, "Test")
        XCTAssertEqual(item?.importance, .important)
        XCTAssertEqual(item?.isDone, false)
        if let createdDate = item?.createdDate {
            XCTAssertEqual(createdDate.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("createdDate is nil")
        }
            
        if let deadline = item?.deadline {
            XCTAssertEqual(deadline.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("deadline is nil")
        }
            
        if let changedDate = item?.changedDate {
            XCTAssertEqual(changedDate.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("changedDate is nil")
        }
    }
    
    func testCSVSerialization() {
        let now = Date()
        let item = ToDoItem(id: "1", text: "Test", importance: .important, isDone: false, createdDate: now, deadline: now, changedDate: now)
        let csv = item.csv
        
        XCTAssertEqual(csv,"\(item.id),\(item.text),важная,\(item.isDone),\(now.timeIntervalSince1970),\(now.timeIntervalSince1970),\(now.timeIntervalSince1970)")
    }
    
    func testCSVDeserialization() {
        let now = Date()
        let csv = "1,Test,важная,false,\(now.timeIntervalSince1970),,\(now.timeIntervalSince1970)"
        
        let item = ToDoItem.parse(csv: csv)
        
        XCTAssertEqual(item?.id, "1")
        XCTAssertEqual(item?.text, "Test")
        XCTAssertEqual(item?.importance, .important)
        XCTAssertEqual(item?.isDone, false)
        XCTAssertEqual(item?.deadline, nil)
        
        if let createdDate = item?.createdDate {
            XCTAssertEqual(createdDate.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("createdDate is nil")
        }
            
            
        if let changedDate = item?.changedDate {
            XCTAssertEqual(changedDate.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("changedDate is nil")
        }

    }
}

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
        
        cache.save(filename: filename)
        
        let newCache = FileCache()
        newCache.load(filename: filename)
        
        XCTAssertEqual(newCache.items.count, 1)
        XCTAssertEqual(newCache.items.first?.id, item.id)
        
        // Удаление временного файла
        if FileManager.default.fileExists(atPath: filename) {
            try? FileManager.default.removeItem(atPath: filename)
        }
    }
}
