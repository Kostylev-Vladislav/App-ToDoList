//
//  App_ToDoListApp.swift
//  App_ToDoList
//
//  Created by Владислав on 21.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct TasksApp: App {
    @StateObject var taskStorage = TaskStorage()
    init() {
        setupLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(taskStorage)
        }
    }
    
    func setupLogging() {
        // Настройка CocoaLumberjack
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        // Настройка различных уровней логирования
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24) // 24 часа
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)

    }
}
