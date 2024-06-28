//
//  TestMainScreen.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//

import SwiftUI

struct TestMainScreen: View {
    @StateObject var taskStorage = TaskStorage.shared
    @State private var showAllTasks = false
    @State var showingAddTaskView = false
    
    var filteredTasks: [ToDoItem] {
        taskStorage.tasks.filter { showAllTasks || !$0.isDone }
    }

    var title: some View {
        HStack {
            Text("Мои дела")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.leading, .trailing, .top])
            Spacer()
        }
        .padding([.leading, .trailing, .top])
    }
    
    var list: some View {
        List {
            Section(header:
                        HStack {
                Text("Выполнено — \(taskStorage.tasks.filter { $0.isDone }.count)")
                
                Spacer()
                Button(showAllTasks ? "Скрыть" : "Показать") {
                    showAllTasks.toggle()
                }
                .font(.custom("SFPro_Font", size: 15))
                
                
                
            }
            ) {
                
                ForEach($taskStorage.tasks, id: \.id) { $task in
                    if showAllTasks {
                        TaskRow(task: $task)
                            .environmentObject(taskStorage)
                            .listRowBackground(Color("BackSecondary"))
            
                    } else {
                        if !task.isDone {
                            TaskRow(task: $task)
                                .environmentObject(taskStorage)
                                .listRowBackground(Color("BackSecondary"))

                                
                        }
                    }
                }
                
            }
        }
        
    }
    
    var addTaskButton: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    showingAddTaskView.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
                .sheet(isPresented: $showingAddTaskView) {
                    AddTaskView()
                }
            }
            
        }
        
    }
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                title
                list
            }
            .scrollContentBackground(.hidden)
            .background(Color("BackPrimary"))
            addTaskButton
                
        }
    }
}





#Preview {
    TestMainScreen()
}
