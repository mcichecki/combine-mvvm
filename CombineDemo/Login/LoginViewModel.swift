//
//  ViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//

import Foundation
import Combine

final class LoginViewModel {
    @Published var login: String = ""
    
    @Published var password: String = ""
    
    lazy var validatedPassword = Publishers.CombineLatest($login, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
}
