//
//  LoginViewController.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 07/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var contentView = LoginView()
    private let viewModel: LoginViewModel
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setUpTargets()
        setUpBindings()
    }
    
    private func setUpTargets() {
        contentView.loginButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.loginTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.login, on: viewModel)
                .store(in: &bindings)
            
            contentView.passwordTextField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            viewModel.validatedPassword
                .receive(on: RunLoop.main)
                .assign(to: \.isValid, on: contentView.loginButton)
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    @objc private func onClick() {
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }
}
