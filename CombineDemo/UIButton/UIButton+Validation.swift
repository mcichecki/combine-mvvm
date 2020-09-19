//
//  UIButton+Validation.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 04/07/2019.
//

import UIKit

extension UIButton {
    var isValid: Bool {
        get {
            return isEnabled && backgroundColor == .valid
        }
        set {
            backgroundColor = newValue ? .valid : .nonValid
            isEnabled = newValue
        }
    }
}
