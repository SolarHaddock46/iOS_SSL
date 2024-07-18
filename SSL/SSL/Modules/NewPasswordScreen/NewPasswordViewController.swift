//
//  ConfirmationCodeViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class NewPasswordViewController: TemplateViewController, NewPasswordViewControllerProtocol {
    private let interactor: NewPasswordBusinessLogic
    private let router: SSLRoutingLogic
    
    private var elements: [ContentElement] = {
       return [
        .heading(text: "Enter a new password"),
        .spacing(height: 16),
        .subtext(text: "Your password must contain at least 8 Latin letters, numbers, or characters"),
        .spacing(height: 16),
        .textField(name: "Password1", placeholder: NSLocalizedString("Password", comment: ""), isSecure: false),
        .spacing(height: 16),
        .textField(name: "Password2", placeholder: NSLocalizedString("Repeat password", comment: ""), isSecure: false),
        .spacing(height: 32),
        .primaryButton(title: "Save", action: #selector(resetButtonTapped(_:)))
       ]
    }()

    init(interactor: NewPasswordBusinessLogic, router: SSLRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView(withElements: elements)
//        initForm()
    }

//    // MARK: - ConfirmationCodeDisplayLogic
//
//    func displayInitForm(_ viewModel: ConfirmationCode.InitForm.ViewModel) {}
//
//    // MARK: - Private
//
//    private func initForm() {
//        interactor.requestInitForm(ConfirmationCode.InitForm.Request())
//    }
    
    @objc func resetButtonTapped(_ sender: UIButton) {
        router.navigate(source: self, destination: .success, data: nil)
    }
}



