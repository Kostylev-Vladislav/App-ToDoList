//
//  DateCollectionViewCell.swift
//  App_ToDoList
//
//  Created by Владислав on 01.07.2024.
//
import UIKit

//MARK: Настройка коллекции с датами

class DateCollectionViewCell: UICollectionViewCell {
    
    private let dateLabel = UILabel()
    private let anotherLabel = UILabel()
    private let monthLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(anotherLabel)
        contentView.addSubview(monthLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        anotherLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            anotherLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            anotherLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            monthLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2)
        ])
        
        contentView.backgroundColor = UIColor.backIOSPrimary
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Date, isSelected: Bool) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d"
        dateLabel.text = formatter.string(from: date)
        
        anotherLabel.text = ""
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
        
        contentView.backgroundColor = isSelected ? .lightGray : UIColor.backIOSPrimary
        contentView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.backIOSPrimary.cgColor
    }
    
    func configureForOther(isSelected: Bool) {
        dateLabel.text = ""
        anotherLabel.text = " Другое "
        monthLabel.text = ""
        contentView.backgroundColor = isSelected ? .lightGray : UIColor.backIOSPrimary
        contentView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.backIOSPrimary.cgColor
    }
}
