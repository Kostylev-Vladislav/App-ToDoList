//
//  ToDoResponse.swift
//  App_ToDoList
//
//  Created by Владислав on 14.07.2024.
//

import Foundation

struct ToDoResponse: Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Int64?
    let isDone: Bool
    let colorHex: String?
    let createdDate: Int64
    let changedDate: Int64
    let last_updated_by: String
    let files: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case isDone = "done"
        case colorHex = "color"
        case createdDate = "created_at"
        case changedDate = "changed_at"
        case deadline
        case last_updated_by
        case files
    }
}


