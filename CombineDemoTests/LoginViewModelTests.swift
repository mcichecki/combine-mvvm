//
//  CombineDemoTests.swift
//  CombineDemoTests
//
//  Created by Michal Cichecki on 04/07/2019.
//

@testable import CombineDemo
import XCTest
import Combine

class LoginViewModelTests: XCTestCase {
    private var subject: LoginViewModel!
    private var mockCredentialsValidator: MockCredentialsValidator!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        mockCredentialsValidator = MockCredentialsValidator()
        subject = LoginViewModel(credentialsValidator: mockCredentialsValidator)
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        mockCredentialsValidator = nil
        subject = nil
        
        super.tearDown()
    }
    
    func test_isInputValid_WhenBothStringsAreEmpty_ShouldProduceFalse() {
        // given
        subject.login = ""
        subject.password = ""
        
        // when
        subject.isInputValid.sink {
            // then
            XCTAssertFalse($0)
        }
        .store(in: &cancellables)
    }
    
    func test_isInputValid_WhenAtLeastOneStringIsEmpty_ShouldProduceFalse() {
        // given
        subject.login = "login"
        subject.password = ""
        
        // when
        subject.isInputValid.sink {
            // then
            XCTAssertFalse($0)
        }
        .store(in: &cancellables)
    }
    
    func test_isInputValid_WhenBothStringsAreLongerThanTwo_ShouldProduceTrue() {
        // given
        subject.login = "login"
        subject.password = "password"
        
        // when
        subject.isInputValid.sink {
            // then
            XCTAssertTrue($0)
        }
        .store(in: &cancellables)
    }
    
    func test_validateCredentials_GivenValidatorReturnsSuccess_ShouldProduceInput() {
        // given
        mockCredentialsValidator.validateCredentialsClosure = { completion in
            completion(.success(()))
        }
        
        subject.validationResult.sink(
            receiveCompletion: { _ in
                XCTFail("Expected to receive value")
            }, receiveValue: { _ in
                return
            })
            .store(in: &cancellables)
        
        // when
        subject.validateCredentials()
        
        // then
        XCTAssertTrue(mockCredentialsValidator.validateCredentialsCalled)
    }
    
    func test_validateCredentials_GivenValidatorReturnsFailure_ShouldProduceError() {
        // given
        mockCredentialsValidator.validateCredentialsClosure = { completion in
            completion(.failure(MockError.error))
        }
        
        subject.validationResult.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected to receive faillure")
                case .failure:
                    return
                }
            }, receiveValue: { _ in
                XCTFail("Expected to receive error")
            })
            .store(in: &cancellables)
        
        // when
        subject.validateCredentials()
        
        // then
        XCTAssertTrue(mockCredentialsValidator.validateCredentialsCalled)
    }
}

// MARK: - MockError

private enum MockError: Error {
    case error
}
