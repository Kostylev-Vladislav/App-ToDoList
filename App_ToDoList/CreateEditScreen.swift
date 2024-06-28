import SwiftUI

struct CreateEditScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @State private var taskText = ""
    @State private var importance: ToDoItem.Importance = .normal
    @State private var hasDeadlineDate = false
    @State private var deadlineDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var selectedColor: Color = .red
    
    @State private var showDatePicker = false
    @State private var showColorPicker = false
    @State private var isEditing = false
    
    @State private var editTask = false
    
    private let taskDateFormatterRu: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    var task: ToDoItem?
    init(task: ToDoItem? = nil) {
        self.task = task
    }
    
    
    private var textField: some View {
        TextField("Что надо сделать?", text: $taskText, axis: .vertical)
            .frame(minHeight: 120)
            .onTapGesture {
                withAnimation {
                    isEditing = true
                }
            }
    }
    
    private var importancePicker: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker("", selection: $importance) {
                Image("DownArrow")
                    .tag(ToDoItem.Importance.unimportant)
                Text("нет")
                    .tag(ToDoItem.Importance.normal)
                Image("RedExclamationMarks")
                    .tag(ToDoItem.Importance.important)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading)
            .frame(maxWidth: 150)
        }
        
    }
    
    private var chooseDate: some View {
        VStack {
            Toggle(isOn: $hasDeadlineDate) {
                Text("Сделать до")
                if hasDeadlineDate {
                    Button(action: {
                        withAnimation {
                            showDatePicker.toggle()
                        }
                    }, label: {
                        Text(taskDateFormatterRu.string(from: deadlineDate))
                            .font(.subheadline)
                    })
                }
            }
        }
    }
    
    private var datePicker: some View {
        DatePicker(
            "",
            selection: $deadlineDate ,
            displayedComponents: [.date]
        )
        .datePickerStyle(GraphicalDatePickerStyle())
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .frame(maxHeight: 350)
        .transition(.opacity)
        .animation(.easeInOut, value: showDatePicker)
        .onChange(of: deadlineDate) {
            withAnimation {
                showDatePicker = false
            }
        }
    }
    
    private var colorPicker: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showColorPicker.toggle()
                }
            }) {
                HStack {
                    Text("Цвет")
                        .foregroundColor(.primary)
                    Spacer()
                    ColorView(color: $selectedColor)
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                }
            }
            if showColorPicker {
                GradientSpectrum(selectedColor: $selectedColor)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private var saveButton: some View {
        Button("Сохранить") {
            if let task = task {
                let newVersionTask = ToDoItem(id: task.id, text: taskText, importance: importance, isDone: task.isDone, createdDate: task.createdDate, deadline: hasDeadlineDate ? deadlineDate : nil, changedDate: Date(), colorHex: selectedColor.hexString)
                TaskStorage.shared.updateTask(newVersionTask)
            } else {
                let newTask = ToDoItem(text: taskText, importance: importance, isDone: false, createdDate: Date(), deadline: hasDeadlineDate ? deadlineDate : nil, changedDate: nil, colorHex: selectedColor.hexString)
                TaskStorage.shared.addTask(newTask)
            }
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(taskText.isEmpty)
    }
    
    private var cancelButton: some View {
        Button("Отменить") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            if let task = task {
                TaskStorage.shared.deleteTask(task)
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Удалить")
                .foregroundColor(editTask ? .red : .gray)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .disabled(!editTask)
    }
    
    private func landscapeView() -> some View {
        HStack {
            if isEditing {
                textField
                    .frame(maxHeight: .infinity)
                    .transition(.move(edge: .bottom))
                    .keyboardAdaptive(isEditing: $isEditing)
            } else {
                HStack {
                    textField
                    Form {
                        Section {
                            importancePicker
                            chooseDate
                            colorPicker
                            if isEditing {
                                datePicker
                            }
                        }
                        .listRowBackground(Color("BackSecondary"))
                        Section {
                            deleteButton
                        }
                        .listRowBackground(Color("BackSecondary"))
                    }
                }
            }
        }
        
    }
    
    private func portraitView() -> some View {
        Form {
            Section {
                textField
                
            }
            .listRowBackground(Color("BackSecondary"))
            
            Section {
                importancePicker
                colorPicker
                chooseDate
                if showDatePicker {
                    datePicker
                }
            }
            .listRowBackground(Color("BackSecondary"))
            
            Section {
                deleteButton
            }
            .listRowBackground(Color("BackSecondary"))
        }
        
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    if horizontalSizeClass == .compact && UIDevice.current.orientation.isLandscape {
                        landscapeView()
                    } else {
                        portraitView()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("BackPrimary"))
            .navigationBarTitle("Дело", displayMode: .inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
        .onAppear {
            if let task = task {
                self.taskText = task.text
                self.importance = task.importance
                self.editTask = true
                if let deadline = task.deadline {
                    self.hasDeadlineDate = true
                    self.deadlineDate = deadline
                }
            }
        }
    }
}

#Preview {
    CreateEditScreen()
}
