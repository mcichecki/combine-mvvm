//
//  ListViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation
import Combine

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

final class ListViewModel {
    enum Section { case players }
    
    @Published var searchText: String = ""
    @Published private(set) var playersViewModels: [PlayerCellViewModel] = [] // not used anymore
    @Published private(set) var players: [Player] = []
    @Published private(set) var state: ListViewModelState = .loading
    
    private let playersService: PlayersServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(playersService: PlayersServiceProtocol = PlayersService()) {
        self.playersService = playersService
        
        $searchText
            .sink { [weak self] in self?.fetchPlayers(with: $0) }
            .store(in: &bindings)
    }
    
    func fetchPlayers(with searchTerm: String?) {
        state = .loading
        
        let searchTermCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
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
