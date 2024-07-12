//
//  MainScreen.swift
//  App_ToDoList
//
//  Created by Владислав on 24.06.2024.
//


import SwiftUI

struct MainScreen: View {
    @StateObject var taskStorage = TaskStorage()
    @State var showingAddTaskView = false
    @State private var isPresentingCalendar = false
    
    var menu: some View {
        Menu {
            Button(
                action: {
                    taskStorage.changeShowButtonValue()
                    taskStorage.updateSortedItems()
                },
                label: {
                    Text(taskStorage.showButtonText)
                }
            )
            Button(
                action: {
                    taskStorage.changeSortButtonValue()
                    taskStorage.updateSortedItems()
                },
                label: {
                    Text(taskStorage.sortButtonText)
                }
            )
        } label: {
            Label {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 18, height: 18)
            } icon: {
                Text("")
            }
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
                        .environmentObject(taskStorage)
                }
        }
        }
        .padding([.leading, .trailing, .top])
    }
    
    var list: some View {
        List {
            Section(header:
                        HStack {
                Text("Выполнено — \(taskStorage.count)")
                
                Spacer()
                menu

            }
            ) {
                ForEach($taskStorage.sortedItems) { task in
                    TaskRow(task: task)
                        .environmentObject(taskStorage)
                        .listRowBackground(Color("BackSecondary"))
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
                        .environmentObject(taskStorage)
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
            .onAppear {
                taskStorage.prepare()
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
