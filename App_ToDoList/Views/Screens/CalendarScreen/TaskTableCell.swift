//
//  TaskTableCell.swift
//  App_ToDoList
//
//  Created by Владислав on 04.07.2024.
//

import UIKit

class TaskTableCell: UITableViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let categoryCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let customTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(categoryCircleView)
        containerView.addSubview(customTextLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(containerView)
        containerView.addSubview(categoryCircleView)
        containerView.addSubview(customTextLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryCircleView.widthAnchor.constraint(equalToConstant: 14),
            categoryCircleView.heightAnchor.constraint(equalToConstant: 14),
            categoryCircleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            categoryCircleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            customTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            customTextLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            customTextLabel.trailingAnchor.constraint(equalTo: categoryCircleView.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(with task: ToDoItem) {
        customTextLabel.text = task.text
        selectionStyle = .none
        if task.isDone {
            customTextLabel.textColor = .gray
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            customTextLabel.attributedText = attributeString
        } else {
            customTextLabel.textColor = .black
            customTextLabel.attributedText = nil
            customTextLabel.text = task.text
        }
        categoryCircleView.backgroundColor = UIColor(task.category.color)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customTextLabel.attributedText = nil
        customTextLabel.textColor = .black
        customTextLabel.text = nil
        categoryCircleView.backgroundColor = nil
        containerView.layer.mask = nil
    }
}
