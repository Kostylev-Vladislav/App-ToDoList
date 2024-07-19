//
//  ConvertToDoListInResponseList.swift
//  App_ToDoList
//
//  Created by Владислав on 18.07.2024.
//

import Foundation

func ConvertToDoListInResponseList(from toDoList: [ToDoItem]) -> [ToDoResponse] {
    var serverList: [ToDoResponse] = []
    for task in toDoList {
        let serverTask = ConvertToDoItemInResponse(from: task)
        serverList.append(serverTask)
    }
    return serverList
}
