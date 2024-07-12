//
//  TaskStorage.swift
//  App_ToDoList
//
//  Created by Владислав on 25.06.2024.
//
import Foundation
import CocoaLumberjackSwift
import FileCacheLibrary

class TaskStorage: ObservableObject {
    let fileCache = FileCache()
    @Published var sortedItems: [ToDoItem] = []
    @Published var showButtonText = "Показать выполненное"
    @Published var sortButtonText = "Сортировать по важности"
    @Published var count = 0
    
    init() {}
    
    
    func updateSortedItems() {
        sortedItems = showButtonText == "Показать выполненное" ? Array(fileCache.tasks.filter({ $0.isDone == false })) : Array(fileCache.tasks)
        if sortButtonText == "Сортировать по добавлению" {
            sortedItems.sort(by: {$0.importance.rawValue > $1.importance.rawValue})
        } else {
            sortedItems.sort(by: {$0.createdDate < $1.createdDate})
        }
    }
    
    func changeShowButtonValue() {
        showButtonText = showButtonText == "Показать выполненное" ? "Скрыть выполненное" : "Показать выполненное"
    }
    
    func changeSortButtonValue() {
        sortButtonText = sortButtonText == "Сортировать по важности" ? "Сортировать по добавлению" : "Сортировать по важности"
    }
    
    
    func addTask(_ task: ToDoItem) {
        fileCache.add(task: task)
        prepare()
        DDLogInfo("Задача добавлена")
    }
    
    func updateTask(_ updatedTask: ToDoItem) {
        fileCache.update(updatedTask: updatedTask)
        prepare()
        DDLogInfo("Задача обновлена")
    }
    
    func deleteTask(_ taskToDelete: ToDoItem) {
        fileCache.remove(id: taskToDelete.id)
        prepare()
        DDLogInfo("Задача удалена")
    }
    
    func updateCount() {
        count = fileCache.tasks.filter({ $0.isDone == true }).count
    }
    
    func prepare() {
        updateSortedItems()
        updateCount()
    }
}
