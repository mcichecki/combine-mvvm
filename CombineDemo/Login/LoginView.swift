//
//  LoginView.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//

import UIKit

final class LoginView: UIView {
    
    lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.backgroundColor = .white
        loginTextField.placeholder = "login"
        loginTextField.textColor = .darkGray
        return loginTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "password"
        passwordTextField.textColor = .darkGray
        return passwordTextField
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log in", for: UIControl.State())
        loginButton.setTitleColor(.white, for: UIControl.State())
        loginButton.backgroundColor = .red
        return loginButton
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [loginTextField, passwordTextField, loginButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {        
        let loginConstraints = [
            loginTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30.0),
            loginTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0),
            loginTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0),
            loginTextField.heightAnchor.constraint(equalToConstant: 30.0)
        ]
        
        let passwordConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10.0),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor, multiplier: 1.0),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
        ]
        
        let loginButtonConstraints = [
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20.0),
            loginButton.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120.0),
            loginButton.heightAnchor.constraint(equalToConstant: 30.0)
        ]
        
        [loginConstraints,
         passwordConstraints,
         loginButtonConstraints]
            .forEach(NSLayoutConstraint.activate(_:))
    }
}
