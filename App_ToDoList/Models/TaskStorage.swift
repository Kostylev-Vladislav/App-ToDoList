//
//  TaskStorage.swift
//  App_ToDoList
//
//  Created by Владислав on 25.06.2024.
//
import Foundation
import CocoaLumberjackSwift
import FileCacheLibrary

final class TaskStorage: ObservableObject {
    let fileCache = FileCache()
    private let networkingService: NetworkingService
    
    @Published var sortedItems: [ToDoItem] = []
    @Published var showButtonText = "Показать выполненное"
    @Published var sortButtonText = "Сортировать по важности"
    @Published var count = 0
    
    init() {
        self.networkingService = NetworkingService()
    }
    
    func fetchTodos() {
        networkingService.getList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    let toDoList = ConvertResponseListInToDoList(from: todos.list)
                    self.fileCache.updateAll(toDoList)
                    
                    DDLogInfo("Список задач загружен с сервера")
                    self.prepare()
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            }
        }
//        prepare()
    }
    
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
        DDLogInfo("Задача добавлена локально")
        prepare()
        networkingService.addItem(item: task)

        fetchTodos()
//        networkingService.updateList(list: fileCache.tasks, revision: 0, completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    DDLogInfo("Обнавлен список на сервере")
//                case .failure(let error):
//                    print("Failed to update list: \(error)")
//                }
//            }
//        })
    }
    
    func updateTask(_ updatedTask: ToDoItem) {
        fileCache.update(updatedTask: updatedTask)
        DDLogInfo("Задача обновлена локально")
        prepare()
        
//        networkingService.updateItem(id: updatedTask.id, item: updatedTask, completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    DDLogInfo("Задача обновлена на сервере")
//                case .failure(let error):
//                    print("Failed to update item: \(error)")
//                }
//            }
//        })
    }
    
    func deleteTask(_ taskToDelete: ToDoItem) {
        fileCache.remove(id: taskToDelete.id)
        DDLogInfo("Задача удалена локально")
        prepare()
        
        networkingService.deleteItem(id: taskToDelete.id, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    DDLogInfo("Задача удалена с сервера")
                case .failure(let error):
                    print("Failed to delete item: \(error)")
                }
            }
        })
    }
    
    func updateCount() {
        count = fileCache.tasks.filter({ $0.isDone == true }).count
    }
    
    func prepare() {
        updateSortedItems()
        updateCount()
    }
}
