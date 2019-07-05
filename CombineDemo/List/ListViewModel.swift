//
//  ListViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation
import Combine

final class ListViewModel {
    @Published var searchText: String = ""
    
    @Published private(set) var playersViewModels: [PlayerCellViewModel] = []
    
    private let playersService: PlayersServiceProtocol
    
    init(playersService: PlayersServiceProtocol = PlayersService()) {
        self.playersService = playersService
        
        _ = $searchText.sink { [weak self] in
            self?.fetchPlayers(with: $0)
        }
    }
    
    func fetchPlayers(with searchTerm: String?) {
        _ = playersService
            .get(searchTerm: searchTerm)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error): print("--- ERROR: \(error)")
                case .finished: print("--- FINISHED")
                }
            }) { [weak self] players in
                self?.playersViewModels = players.map { PlayerCellViewModel(player: $0) }
        }
    }
}
