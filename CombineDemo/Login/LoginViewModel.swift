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
    @Published var isLoading = false
    var validationResult = PassthroughSubject<Void, Error>()
    
    lazy var isInputValid = Publishers.CombineLatest($login, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    func validateCredentials() {
        isLoading = true
        
        let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.isLoading = false
            self.validationResult.send(())
        }
    }
}
