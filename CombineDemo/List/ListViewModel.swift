//
//  ListViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation
import Combine

enum ListViewModelError: Error, Equatable {
    case playersFetch
}

enum ListViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ListViewModelError)
}

final class ListViewModel {
    enum Section { case players }

    @Published private(set) var players: [Player] = []
    @Published private(set) var state: ListViewModelState = .loading
    private var currentSearchQuery: String = ""
    
    private let playersService: PlayersServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(playersService: PlayersServiceProtocol = PlayersService()) {
        self.playersService = playersService
    }

    func search(query: String) {
        currentSearchQuery = query
        fetchPlayers(with: query)
    }

    func retrySearch() {
        fetchPlayers(with: currentSearchQuery)
    }
}

extension ListViewModel {
    private func fetchPlayers(with searchTerm: String?) {
        state = .loading
        
        let searchTermCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.playersFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let searchTermValueHandler: ([Player]) -> Void = { [weak self] players in
            self?.players = players
        }
        
        playersService
            .get(searchTerm: searchTerm)
            .sink(receiveCompletion: searchTermCompletionHandler, receiveValue: searchTermValueHandler)
            .store(in: &bindings)
    }
}
