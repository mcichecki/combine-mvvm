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
    let validationResult = PassthroughSubject<Void, Error>()
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($login, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    private let credentialsValidator: CredentialsValidatorProtocol
    
    init(credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
        self.credentialsValidator = credentialsValidator
    }
    
    func validateCredentials() {
        isLoading = true
        
        credentialsValidator.validateCredentials(login: login, password: password) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                self?.validationResult.send(())
            case let .failure(error):
                self?.validationResult.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - CredentialsValidatorProtocol

protocol CredentialsValidatorProtocol {
    func validateCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void)
}

/// This class acts as an example of asynchronous credentials validation
/// It's for demo purpose only. In the real world it would make an actual request or use other authentication method
final class CredentialsValidator: CredentialsValidatorProtocol {
    func validateCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void) {
        let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            // hardcoded success
            completion(.success(()))
        }
    }
}
