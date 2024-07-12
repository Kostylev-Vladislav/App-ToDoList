//
//  CalendarScreen.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//

import UIKit
import SwiftUI



class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var collectionView: UICollectionView!
    var tableView: UITableView!
    var separator: UIView!//  
    var tasks: [ToDoItem]
    var dates: [Date]
    var taskStorage: TaskStorage
    var selectedDate: Date?
    
    
    
    init(taskStorage: TaskStorage) {
        self.taskStorage = taskStorage
        self.tasks = taskStorage.fileCache.tasks
        self.dates = getUniqueDays(from: tasks)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let visibleSections = tableView.indexPathsForVisibleRows?.compactMap({ $0.section }) {
            if !visibleSections.isEmpty {
                var sectionDate: Date?
                if visibleSections.first ?? 1 < dates.count {
                    sectionDate = dates[visibleSections.first ?? 0]
                } else {
                    sectionDate = nil
                }
                
                if selectedDate != sectionDate {
                    selectedDate = sectionDate
                    scrollToDate(sectionDate)
                }
                
            }
        }
    }
    func scrollToSelectedDate() {
        if let date = selectedDate {
            if let index = dates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                print("scroll \(index)")
                if tableView.numberOfSections > index, tableView.numberOfRows(inSection: index) > 0 {
                    tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
                }
            }
        } else {
            print("scroll \(tableView.numberOfSections - 1)")
            tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections - 1), at: .top, animated: true)
        }
    }
    
    func scrollToDate(_ date: Date?) {
        if let date = date {
            if let index = dates.firstIndex(of: date) {
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        } else {
            collectionView.scrollToItem(at: IndexPath(item: collectionView.numberOfItems(inSection: 0) - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backIOSPrimary
        
        setupNavigationBar()
        setupCollectionView()
        setupSeparator()
        setupTableView()
        setupAddButton()
        loadDates()
    }
    
    override func viewDidLayoutSubviews() {
        self.tasks = taskStorage.fileCache.tasks
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationItem = UINavigationItem(title: "Мои дела")
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func setupSeparator() {
        separator = UIView()
        separator.backgroundColor = UIColor.systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    private func setupAddButton() {

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        let addButton = UIButton(configuration: config, primaryAction: UIAction { _ in
            self.addTask()
        })
        
        let largePlusSymbol = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        addButton.setImage(largePlusSymbol, for: .normal)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowRadius = 10
        
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func loadDates() {
        selectedDate = dates.first
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @objc func addTask() {
        let createEditScreen = UIHostingController(rootView: CreateEditScreen().environmentObject(taskStorage))
        createEditScreen.modalPresentationStyle = .automatic
        present(createEditScreen, animated: true, completion: nil)
        loadDates()

    }
}



