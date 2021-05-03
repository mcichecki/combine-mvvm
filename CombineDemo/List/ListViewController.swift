//
//  ListViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<ListViewModel.Section, Player>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListViewModel.Section, Player>
    
    private lazy var contentView = ListView()
    private let viewModel: ListViewModel
    private var bindings = Set<AnyCancellable>()
    
    private var dataSource: DataSource!
    
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
        configureDataSource()
        setUpBindings()
    }
    
    private func setUpTableView() {
        contentView.collectionView.register(
            PlayerCollectionCell.self,
            forCellWithReuseIdentifier: PlayerCollectionCell.identifier)
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
            viewModel.$players
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateSections()
                })
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
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.players])
        snapshot.appendItems(viewModel.players)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ListViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: contentView.collectionView,
            cellProvider: { (collectionView, indexPath, player) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlayerCollectionCell.identifier,
                    for: indexPath) as? PlayerCollectionCell
                cell?.viewModel = PlayerCellViewModel(player: player)
                return cell
            })
    }
}
