//
//  CalendarViewControllerRepresentable.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//

import SwiftUI
import UIKit

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject var taskStorage: TaskStorage
    func makeUIViewController(context: Context) -> CalendarViewController {
        let vc = CalendarViewController(taskStorage: taskStorage)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
    }
}
