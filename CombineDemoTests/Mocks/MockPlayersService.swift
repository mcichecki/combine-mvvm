//
//  MockPlayersService.swift
//  CombineDemoTests
//
//  Created by Michal Cichecki on 21/10/2021.
//  Copyright © 2021 codeuqest. All rights reserved.
//

import Foundation
import Combine
@testable import CombineDemo

final class MockPlayersService: PlayersServiceProtocol {
    var getArguments: [String?] = []
    var getCallsCount: Int = 0

    var getResult: Result<[Player], Error> = .success([])

    func get(searchTerm: String?) -> AnyPublisher<[Player], Error> {
        getArguments.append(searchTerm)
        getCallsCount += 1

        return getResult.publisher.eraseToAnyPublisher()
    }
}
