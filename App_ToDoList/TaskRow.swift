//
//  TaskRow.swift
//  App_ToDoList
//
//  Created by Владислав on 25.06.2024.
//

import SwiftUI

struct TaskRow: View {
    @Binding var task: ToDoItem
    @EnvironmentObject var taskStorage: TaskStorage
    @State private var isPresentingModal = false
    
    
    var body: some View {
        HStack {
            if task.importance == .important {
                Image(task.isDone ? "CheckmarkCircle" : "RedCircle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .onTapGesture {
                        task.isDone.toggle()
                        taskStorage.updateTask(task)
                    }
                Image("RedExclamationMarks")
            } else {
                Image(task.isDone ? "CheckmarkCircle" : "EmptyCircle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .onTapGesture {
                        task.isDone.toggle()
                        taskStorage.updateTask(task)
                    }
            }
            VStack(alignment: .leading) {
                Text(task.text)
                    .strikethrough(task.isDone, color: .gray)
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .lineLimit(3)
                    .onTapGesture {
                        isPresentingModal = true
                    }
                
                if let deadline = task.deadline {
                    HStack {
                        Image(systemName: "calendar")
                        Text("\(deadline, formatter: taskDateFormatter)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            Circle()
                .foregroundColor(Color(hex: task.colorHex ?? "FFFFFF"))
                .frame(width: 20, height: 20)
            
            Image("NavigationArrow")
                .frame(width: 15)
                .onTapGesture {
                    isPresentingModal = true
                }
            
        }
        .frame(maxWidth: .infinity)
        .swipeActions(edge: .leading) {
            Button(action: {
                task.isDone.toggle()
                taskStorage.updateTask(task)
            }) {
                Label("Done", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: {
                taskStorage.deleteTask(task)
            }) {
                Label("Delete", systemImage: "trash")
            }
            Button(action: {
                isPresentingModal = true
            }) {
                Label("Info", systemImage: "info.circle")
                    .background(Color("Color [Light]Gray Light"))
            }
        }
        .sheet(isPresented: $isPresentingModal) {
            CreateEditScreen(task: task)
        }
    }
}




extension ToDoItem: Identifiable {}

private let taskDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    MainScreen()
}
