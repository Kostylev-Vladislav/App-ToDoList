import SwiftUI

struct CreateEditScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskStorage: TaskStorage
    
    @State private var taskText = ""
    @State private var importance: Importance = .basic
    @State private var hasDeadlineDate = false
    @State private var deadlineDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var selectedColor: Color = .clear
    @State private var selectedCategory: TaskCategory = .other
    
    @State private var showCategoryPicker = false
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
    
    var customPlaceholder: some View {
        Text("Что надо сделать?")
            .foregroundStyle(.gray)
    }
    
    private var textField: some View {
        ZStack(alignment: .topLeading) {
            if taskText.isEmpty {
                customPlaceholder
            }
            TextField("", text: $taskText, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(.none)
                .modifier(TextFieldFrameModifier())
        }
        .padding()
        .padding(.bottom, 6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackSecondary"))
        )
    }
    
    
    private var importancePicker: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker("", selection: $importance) {
                Image("DownArrow")
                    .tag(Importance.low)
                Text("нет")
                    .tag(Importance.basic)
                Image("RedExclamationMarks")
                    .tag(Importance.important)
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
                        .frame(width: 25, height: 25)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
            if showColorPicker {
                GradientSpectrum(selectedColor: $selectedColor)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private var categoryPicker: some View {
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
        .pickerStyle(MenuPickerStyle())
    }
    
    private var saveButton: some View {
        Button("Сохранить") {
            if let task = task {
                let newVersionTask = ToDoItem(id: task.id, text: taskText, importance: importance, isDone: task.isDone, createdDate: task.createdDate, deadline: hasDeadlineDate ? deadlineDate : nil, changedDate: Date(), colorHex: selectedColor.hexString, category: selectedCategory)
                taskStorage.updateTask(newVersionTask)
            } else {
                let newTask = ToDoItem(text: taskText, importance: importance, isDone: false, createdDate: Date(), deadline: hasDeadlineDate ? deadlineDate : nil, changedDate: nil, colorHex: selectedColor.hexString, category: selectedCategory)
                taskStorage.addTask(newTask)
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
                taskStorage.deleteTask(task)
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
                            categoryPicker
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
                categoryPicker
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
