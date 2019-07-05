//
//  PlayersService.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol PlayersServiceProtocol {
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error>
}

final class PlayersService: PlayersServiceProtocol {
    
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<[Player], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(searchTerm: searchTerm) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let players = try JSONDecoder().decode(PlayerData.self, from: data)
                    promise(.success(players.data))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
            .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(searchTerm: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free-nba.p.rapidapi.com"
        components.path = "/players"
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            components.queryItems = [
                URLQueryItem(name: "search", value: searchTerm)
            ]
        }
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "X-RapidAPI-Host": "free-nba.p.rapidapi.com",
            "X-RapidAPI-Key": apiKey
        ]
        return urlRequest
    }
}
