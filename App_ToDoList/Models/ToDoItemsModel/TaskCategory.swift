//
//  TaskCategory.swift
//  App_ToDoList
//
//  Created by Владислав on 05.07.2024.
//

import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case work = "Работа"
    case study = "Учеба"
    case hobby = "Хобби"
    case other = "Другое"

    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .work:
            return .red
        case .study:
            return .blue
        case .hobby:
            return .green
        case .other:
            return .clear
        }
    }
}
