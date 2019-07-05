//
//  ListView.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import UIKit

final class ListView: UIView {
    // TODO: lazy var without block?
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "NBA Player"
        searchTextField.textColor = .darkGray
        return searchTextField
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        let subviews = [searchTextField, tableView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setUpConstraints() {
        let defaultMargin: CGFloat = 4.0
        
        let searchTextFieldConstraints = [
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: defaultMargin),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultMargin),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
            searchTextField.heightAnchor.constraint(equalToConstant: 30.0)
        ]
        
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: defaultMargin),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        [searchTextFieldConstraints, tableViewConstraints]
            .forEach(NSLayoutConstraint.activate(_:))
    }
}
