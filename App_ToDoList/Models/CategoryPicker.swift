//
//  CategoryPicker.swift
//  App_ToDoList
//
//  Created by Владислав on 05.07.2024.
//

import SwiftUI


struct CategoryPicker: View {
    @Binding var selectedCategory: TaskCategory
    
    var body: some View {
        Picker("Категория", selection: $selectedCategory) {
            ForEach(TaskCategory.allCases) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    Circle()
                        .fill(category.color)
                        .frame(width: 20, height: 20)
                }
                .padding()
                .tag(category)
            }
        }
        .pickerStyle(DefaultPickerStyle())
    }
}


