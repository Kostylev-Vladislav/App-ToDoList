//
//  MainScreen.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//


import SwiftUI

struct MainScreen: View {
    @StateObject var taskStorage = TaskStorage.shared
    @State var showingAddTaskView = false
    @State private var showCompleted = false
    @State private var sortByImportance = false
    @State private var showMenu = false
    @State private var isPresentingCalendar = false
    
    
    var filtredTasks: [ToDoItem] {
        if !showCompleted {
            taskStorage.tasks.sorted { sortByImportance ? $0.importance.rawValue > $1.importance.rawValue : true }
        } else {
            taskStorage.tasks.sorted { sortByImportance ? $0.createdDate > $1.createdDate : true }
        }
    }
    

    var title: some View {
        VStack {
            HStack {
                Text("Мои дела")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing, .top])
                Spacer()
                Button(action: {
                    isPresentingCalendar = true
                }) {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                        
                    
                }
                .padding([.trailing, .top])
                .sheet(isPresented: $isPresentingCalendar) {
                    CalendarViewControllerRepresentable()
                }
//                Button(action: {
//                    withAnimation {
//                        showMenu.toggle()
//                    }
//                }) {
//                    Image("Filter")
//                        .frame(maxWidth: 100)
//                        .padding(.top, 16)
//                    
//                }
        }

//            if showMenu {
//                VStack {
//                    Toggle("Скрыть/Показать выполненное", isOn: $showCompleted)
//                        .padding()
//                    Toggle("Сортировка по добавлению/важности", isOn: $sortByImportance)
//                        .padding()
//                }
//                .background(Color("BackSecondary"))
//                .cornerRadius(8)
//                .padding()
//            }
        }
        .padding([.leading, .trailing, .top])
    }
    
    var list: some View {
        List {
            Section(header:
                        HStack {
                Text("Выполнено — \(taskStorage.tasks.filter { $0.isDone }.count)")
                
                Spacer()
                Button(showCompleted ? "Скрыть" : "Показать") {
                    showCompleted.toggle()
                }
                .font(.custom("SFPro_Font", size: 15))
            }
            ) {
                ForEach($taskStorage.tasks, id: \.id) { $task in
                    if showCompleted {
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
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
                
                .sheet(isPresented: $showingAddTaskView) {
                    CreateEditScreen()
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
    MainScreen()
}
