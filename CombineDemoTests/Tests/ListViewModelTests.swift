//
//  ListViewModelTests.swift
//  CombineDemoTests
//
//  Created by Michal Cichecki on 21/10/2021.
//  Copyright © 2021 codeuqest. All rights reserved.
//

import Foundation
import XCTest
import Combine
@testable import CombineDemo

final class ListViewModelTests: XCTestCase {
    private var subject: ListViewModel!
    private var mockPlayersService: MockPlayersService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockPlayersService = MockPlayersService()
        subject = ListViewModel(playersService: mockPlayersService)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockPlayersService = nil
        subject = nil

        super.tearDown()
    }

    func test_searchText_shouldCallService() {
        // when
        subject.search(query: "test")

        // then
        XCTAssertEqual(mockPlayersService.getCallsCount, 1)
        XCTAssertEqual(mockPlayersService.getArguments.first, "test")
    }

    func test_retrySearch_givenSearchWasPerformed_shouldUseCurrentQuery() {
        // given (setup to update search query)
        subject.search(query: "test")
        XCTAssertEqual(mockPlayersService.getCallsCount, 1)
        XCTAssertEqual(mockPlayersService.getArguments.first, "test")

        // when
        subject.retrySearch()

        // then
        XCTAssertEqual(mockPlayersService.getCallsCount, 2)
        XCTAssertEqual(mockPlayersService.getArguments.last, "test")
    }

    func test_searchText_givenServiceCallSucceeds_shouldUpdatePlayers() {
        // given
        mockPlayersService.getResult = .success(Constants.players)

        // when
        subject.search(query: "test")

        // then
        XCTAssertEqual(mockPlayersService.getCallsCount, 1)
        XCTAssertEqual(mockPlayersService.getArguments.last, "test")
        subject.$players
            .sink { XCTAssertEqual($0, Constants.players) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }

    func test_searchText_givenServiceCallFails_shouldUpdateStateWithError() {
        // given
        mockPlayersService.getResult = .failure(MockError.error)

        // when
        subject.search(query: "test")

        // then
        XCTAssertEqual(mockPlayersService.getCallsCount, 1)
        XCTAssertEqual(mockPlayersService.getArguments.last, "test")
        subject.$players
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .error(.playersFetch)) }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

extension ListViewModelTests {
    enum Constants {
        static let players = [
            Player(firstName: "Kobe", lastName: "Bryant", team: "LAL"),
            Player(firstName: "Dirk", lastName: "Nowitzki", team: "DAL")
        ]
    }
}
