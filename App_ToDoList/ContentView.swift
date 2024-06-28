//import SwiftUI
//
//struct AddTaskView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var newTaskText = ""
//    @State private var importance: ToDoItem.Importance = .normal
//    @State private var hasDueDate = false
//    @State private var dueDate = Date()
//    @Binding var tasks: [ToDoItem]
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    TextField("Что надо сделать?", text: $newTaskText)
//                        .padding()
//                }
//                
//                Section {
//                    HStack {
//                        Text("Важность")
//                        Spacer()
//                        Picker("", selection: $importance) {
//                            ForEach(ToDoItem.Importance.allCases, id: \.self) { importance in
//                                Text(importance.rawValue).tag(importance)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }
//                    
//                    Toggle(isOn: $hasDueDate) {
//                        Text("Сделать до")
//                    }
//                    
//                    if hasDueDate {
//                        DatePicker("Выберите дату", selection: $dueDate, displayedComponents: .date)
//                    }
//                }
//                
//                Section {
//                    Button(action: {
//                        // Action for delete (if needed)
//                    }) {
//                        Text("Удалить")
//                            .foregroundColor(.red)
//                    }
//                    .disabled(true)
//                }
//            }
//            .navigationBarTitle("Дело", displayMode: .inline)
//            .navigationBarItems(
//                leading: Button("Отменить") {
//                    presentationMode.wrappedValue.dismiss()
//                },
//                trailing: Button("Сохранить") {
//                    let newTask = ToDoItem(text: newTaskText, importance: importance, deadline: hasDueDate ? dueDate : nil)
//                    tasks.append(newTask)
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .disabled(newTaskText.isEmpty)
//            )
//        }
//    }
//}
//
//extension ToDoItem: Identifiable {}
//
//private let taskDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    return formatter
//}()
