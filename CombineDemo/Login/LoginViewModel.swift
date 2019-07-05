//
//  ViewModel.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation
import Combine

final class LoginViewModel {
    @InitialPublished var login: String = ""
    
    @InitialPublished var password: String = ""
    
    lazy var validatedPassword = Publishers.CombineLatest($login, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
}
