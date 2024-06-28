//
//  App_ToDoListApp.swift
//  App_ToDoList
//
//  Created by Владислав on 21.06.2024.
//

import SwiftUI

@main
struct TasksApp: App {
    @StateObject var taskStorage = TaskStorage.shared
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(taskStorage)
        }
    }
}
