//
//  ListViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private lazy var contentView = ListView()
    private let viewModel: ListViewModel
    private var bindings = Set<AnyCancellable>()
    
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
            contentView.searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.searchText, on: viewModel)
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            let viewModelsValueHandler: ([PlayerCellViewModel]) -> Void = { [weak self] _ in
                self?.contentView.tableView.reloadData()
            }
            
            viewModel.$playersViewModels
                .receive(on: RunLoop.main)
                .sink(receiveValue: viewModelsValueHandler)
                .store(in: &bindings)
            
            let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.contentView.startLoading()
                case .finishedLoading:
                    self?.contentView.finishLoading()
                case .error(let error):
                    self?.contentView.finishLoading()
                    self?.showError(error)
                }
            }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
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
