//
//  PlayerCellViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation
import Combine

final class PlayerCellViewModel {
    @Published var playerName: String = ""
    
    @Published var team: String = ""
        
    private let player: Player
    
    init(player: Player) {
        self.player = player
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        playerName = [player.firstName, player.lastName].joined(separator: " ")
        team = player.team.abbreviation
    }
}
