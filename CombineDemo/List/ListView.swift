//
//  ListView.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import UIKit

final class ListView: UIView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "NBA Player"
        searchTextField.textColor = .darkGray
        return searchTextField
    }()
    
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        let subviews = [searchTextField, collectionView, activityIndicationView]
        
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: defaultMargin),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let activityIndicatorViewConstraints = [
            activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
        ]
        
        [searchTextFieldConstraints, tableViewConstraints, activityIndicatorViewConstraints]
            .forEach(NSLayoutConstraint.activate(_:))
    }
    
    func startLoading() {
        collectionView.isUserInteractionEnabled = false
        searchTextField.isUserInteractionEnabled = false
        
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        collectionView.isUserInteractionEnabled = true
        searchTextField.isUserInteractionEnabled = true
        
        activityIndicationView.stopAnimating()
    }
    
    private func setUpViews() {
        collectionView.backgroundColor = .white
        searchTextField.autocorrectionType = .no
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 5
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
