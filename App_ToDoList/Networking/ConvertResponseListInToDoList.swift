//
//  ConvertResponseListInToDoList.swift
//  App_ToDoList
//
//  Created by Владислав on 18.07.2024.
//

import Foundation

func ConvertResponseListInToDoList(from serverList: [ToDoResponse]) -> [ToDoItem] {
    var list: [ToDoItem] = []
    for serverTask in serverList {
        let task = ConvertResponseInToDoItem(from: serverTask)
        list.append(task)
    }
    return list
}
