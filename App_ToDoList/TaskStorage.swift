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
    
    @Published var tasks: [ToDoItem] = [ToDoItem(text: "Пример задачи", importance: .important, isDone: false, createdDate: Date(), deadline: nil, changedDate: nil, colorHex: "FF3B30")]
    
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
