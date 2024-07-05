//
//  TaskStorage.swift
//  App_ToDoList
//
//  Created by Владислав on 25.06.2024.
//

import Foundation

class TaskStorage: ObservableObject {
    static var shared = TaskStorage()
    
    private init() {}
    
    @Published var tasks: [ToDoItem] = [ToDoItem(text: "Пример задачи 1", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "F12B30", category: .hobby), ToDoItem(text: "Пример задачи 2", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 1000000), changedDate: nil, colorHex: "5FFF30", category: .work), ToDoItem(text: "Пример задачи 3", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B50"), ToDoItem(text: "Пример задачи 4", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "953B30"), ToDoItem(text: "Пример задачи 5", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 6", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "F03B00"), ToDoItem(text: "Пример задачи 7", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 8", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "0F3B30"), ToDoItem(text: "Пример задачи", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF9B30"), ToDoItem(text: "Пример задачи 9", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 10", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 11", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 12", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 13", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 2000000), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 14", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "BF3B30"), ToDoItem(text: "Пример задачи 15", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 16", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 17", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B00"), ToDoItem(text: "Пример задачи", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "FF3B30", category: .study), ToDoItem(text: "Пример задачи 18", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30"), ToDoItem(text: "Пример задачи 19", importance: .important, isDone: false, createdDate: Date(), deadline: Date(), changedDate: nil, colorHex: "FF3B30", category: .work), ToDoItem(text: "Пример задачи 20", importance: .important, isDone: false, createdDate: Date(), deadline: Date(timeIntervalSinceNow: 3000000), changedDate: nil, colorHex: "FF3030")]
    
    
    
    func addTask(_ task: ToDoItem) {
        tasks.append(task)
        print("Задача добавлена")
    }
    
    func getTasks() -> [ToDoItem] {
        return tasks
    }
    
    func updateTask(_ updatedTask: ToDoItem) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            print("Задача обновлена")
        }
    }
    
    func deleteTask(_ taskToDelete: ToDoItem) {
        if let index = tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
            tasks.remove(at: index)
            print("Задача удалена")
        }
    }
}
