//
//  UITextField+Publisher.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 03/07/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
            .map { $0.text ?? "" } // mapping UITextField to extract text
            .eraseToAnyPublisher()
    }
}
