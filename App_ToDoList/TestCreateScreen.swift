//
//  TestCreateScreen.swift
//  App_ToDoList
//
//  Created by Владислав on 25.06.2024.
//

import SwiftUI


import SwiftUI

struct Contents: View {
    @State private var showCompleted = true
    @State private var sortByImportance = false
    @State private var showMenu = false

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                Text("Фильтры")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if showMenu {
                VStack {
                    Toggle("Скрыть/показать выполненное", isOn: $showCompleted)
                        .padding()
                    Toggle("Сортировка по добавлению/важности", isOn: $sortByImportance)
                        .padding()
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            }

            // Пример отображения задач (упрощённый)
            List {
                Text("Задача 1")
                Text("Задача 2")

            }
        }
        .padding()
    }
}

#Preview {
    Contents()
}
