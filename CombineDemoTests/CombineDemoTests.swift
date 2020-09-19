//
//  CombineDemoTests.swift
//  CombineDemoTests
//
//  Created by Michal Cichecki on 04/07/2019.
//

@testable import CombineDemo
import XCTest

class LoginViewModelTests: XCTestCase {
    private var subject: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        
        subject = LoginViewModel()
    }

    override func tearDown() {
        subject = nil
        
        super.tearDown()
    }
    
    func test_validatedPassword_WhenBothStringsAreEmpty_ShouldProduceFalse() {
        // given
        subject.login = ""
        subject.password = ""
        
        // when
        _ = subject.validatedPassword.sink {
            // then
            XCTAssertFalse($0)
        }
    }
    
    func test_validatedPassword_WhenAtLeastOneStringIsEmpty_ShouldProduceFalse() {
        // given
        subject.login = "login"
        subject.password = ""
        
        // when
        _ = subject.validatedPassword.sink {
            // then
            XCTAssertFalse($0)
        }
    }
    
    func test_validatedPassword_WhenBothStringsAreLongerThanTwo_ShouldProduceTrue() {
        // given
        subject.login = "login"
        subject.password = "password"
        
        // when
        _ = subject.validatedPassword.sink {
            // then
            XCTAssertTrue($0)
        }
    }

}
