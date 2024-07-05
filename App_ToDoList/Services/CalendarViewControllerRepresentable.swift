//
//  CalendarViewControllerRepresentable.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//

import SwiftUI
import UIKit

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        return CalendarViewController()
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
    }
}
