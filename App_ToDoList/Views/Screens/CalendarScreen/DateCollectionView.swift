//
//  DateCollectionsView.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//

import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 65)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCell")
        collectionView.backgroundColor = UIColor.backIOSPrimary
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        
        if indexPath.row < dates.count {
            let date = dates[indexPath.row]
            cell.configure(with: date, isSelected: date == selectedDate)
        } else {
            cell.configureForOther(isSelected: selectedDate == nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < dates.count {
            selectedDate = dates[indexPath.row]
        } else {
            selectedDate = nil
        }
        scrollToSelectedDate()
        collectionView.reloadData()
    }
}
