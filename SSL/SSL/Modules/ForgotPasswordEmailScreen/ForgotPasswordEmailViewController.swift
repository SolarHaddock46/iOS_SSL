//
//  ConfirmationCodeViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ForgotPasswordEmailViewController: TemplateViewController, ForgotPasswordEmailViewControllerProtocol {
    private let interactor: ForgotPasswordEmailBusinessLogic
    private let router: SSLRoutingLogic
    
    private var elements: [ContentElement] = {
       return [
        .heading(text: "Reset password", topMargin: 0),
        .subtext(text: "Enter the email address associated with your account", topMargin: 32),
        .textField(name: "Email", placeholder: NSLocalizedString("Email", comment: ""), isSecure: false, topMargin: 16),
        .primaryButton(title: "Reset", action: #selector(resetButtonTapped(_:)), topMargin: 11)
       ]
    }()

    init(interactor: ForgotPasswordEmailBusinessLogic, router: SSLRoutingLogic) {
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
        router.navigate(source: self, destination: .confirmationCode, data: nil)
    }
}



