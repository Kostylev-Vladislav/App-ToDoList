//
//  TasksTableView.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//

import UIKit

//MARK: Настройка таблицы задач

extension CalendarViewController {
    
    func setupTableView() {

        tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(TaskTableCell.self, forCellReuseIdentifier: "TaskTableCell")
        tableView.backgroundColor = UIColor.backIOSPrimary
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 350))
        tableView.tableFooterView = footerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dates.count {
            let deadlineTask =  tasks.filter { task in
                if let deadline = task.deadline {
                    return Calendar.current.isDate(deadline, inSameDayAs: dates[section])
                }
                return false
            }
            return deadlineTask.count
        } else {
            return tasks.filter {$0.deadline == nil}.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < dates.count {
            let date = dates[section]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(from: date)
        } else {
            return "Другое"
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableCell", for: indexPath) as! TaskTableCell
        
        let tasksForSection = getTasksForSection(at: indexPath)
        let task = tasksForSection[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    //MARK: настройка свайпов таблицы
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tasksForSection = getTasksForSection(at: indexPath)
        var task = tasksForSection[indexPath.row]
        let completeAction = UIContextualAction(style: .normal, title: "Выполнено") { (action, view, completionHandler) in
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                if !task.isDone {
                    self.tasks[index].isDone = true
                    task.isDone = true
                    TaskStorage.shared.updateTask(task)
                    tableView.performBatchUpdates({
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }, completion: { _ in
                        completionHandler(true)
                    })
                }
                
            }
            completionHandler(true)
        }
        completeAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tasksForSection = getTasksForSection(at: indexPath)
        var task = tasksForSection[indexPath.row]
        let uncompleteAction = UIContextualAction(style: .normal, title: "Активное") { (action, view, completionHandler) in
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                if task.isDone {
                    self.tasks[index].isDone = false
                    task.isDone = false
                    TaskStorage.shared.updateTask(task)
                    tableView.performBatchUpdates({
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }, completion: { _ in
                        completionHandler(true)
                    })
                    
                }
            }
            completionHandler(true)
        }
        uncompleteAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [uncompleteAction])
    }
    
    //MARK: скругление углов таблицы
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TaskTableCell else { return }
        
        let cornerRadius: CGFloat = 16.0
        var corners: UIRectCorner = []

        if indexPath.row == 0 {
            corners.insert([.topLeft, .topRight])
        }
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.insert([.bottomLeft, .bottomRight])
        }

        let maskPath = UIBezierPath(roundedRect: cell.containerView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        cell.containerView.layer.mask = maskLayer

        cell.backgroundColor = UIColor.backIOSPrimary
        cell.containerView.backgroundColor = .white
    }
    
    private func getTasksForSection(at indexPath: IndexPath) -> [ToDoItem] {
        if indexPath.section < dates.count {
            return tasks.filter { task in
                if let deadline = task.deadline {
                    return Calendar.current.isDate(deadline, inSameDayAs: dates[indexPath.section])
                }
                return false
            }
        } else {
            return tasks.filter { $0.deadline == nil }
        }
    }
}
