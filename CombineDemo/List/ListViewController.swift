//
//  ListViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    private lazy var contentView = ListView()
    
    private let viewModel: ListViewModel
    
    init(viewModel: ListViewModel = ListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        
        setUpTableView()
        setUpBindings()
    }
    
    private func setUpTableView() {
        contentView.tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
        contentView.tableView.dataSource = self
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
            _ = contentView.searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.searchText, on: viewModel)
        }
        
        func bindViewModelToView() {
            _ = viewModel.$playersViewModels
                .receive(on: RunLoop.main)
                .sink { [weak self] viewModels in
                    self?.contentView.tableView.reloadData()
            }
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playersViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath)
        
        guard let playerCell = dequeuedCell as? PlayerTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        
        playerCell.viewModel = viewModel.playersViewModels[indexPath.row]
        return playerCell
    }
}
