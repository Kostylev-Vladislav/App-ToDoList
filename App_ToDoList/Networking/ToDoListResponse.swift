//
//  ToDoListResponse.swift
//  App_ToDoList
//
//  Created by Владислав on 13.07.2024.
//

import Foundation

struct ToDoListResponse: Codable {
    let status: String
    let list: [ToDoResponse]
    let revision: Int32
}
