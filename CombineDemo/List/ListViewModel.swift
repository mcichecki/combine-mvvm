//
//  ListViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation
import Combine

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

final class ListViewModel {
    @Published var searchText: String = ""
    
    @Published private(set) var playersViewModels: [PlayerCellViewModel] = []
    
    @Published private(set) var state: ListViewModelState = .loading
    
    private var searchTextCancellable: AnyCancellable?
    
    private let playersService: PlayersServiceProtocol
    
    init(playersService: PlayersServiceProtocol = PlayersService()) {
        self.playersService = playersService
        
        searchTextCancellable = $searchText.sink { [weak self] in
            self?.fetchPlayers(with: $0)
        }
    }
    
    func fetchPlayers(with searchTerm: String?) {
        state = .loading
        _ = playersService
            .get(searchTerm: searchTerm)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error): self?.state = .error(error)
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] players in
                self?.playersViewModels = players.map { PlayerCellViewModel(player: $0) }
        }
    }
}
