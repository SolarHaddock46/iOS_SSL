//
//  ConfirmationCodeViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ConfirmationCodeViewController: TemplateViewController, ConfirmationCodeViewControllerProtocol {
    private let interactor: ConfirmationCodeBusinessLogic
    private var router: SSLRoutingLogic
    private var elements: [ContentElement] = {
       return [
        .heading(text: "Confirmation code", topMargin: 0),
        .subtext(text: "We have sent you a confirmation code, please check your email", topMargin: 16),
        .textField(name: "Confirmation code", placeholder: NSLocalizedString("Confirmation code", comment: ""), isSecure: false, topMargin: 32),
        .secondaryButton(title: "Send again", action: #selector(sendAgainButtonTapped(_:)), topMargin: 8),
        .primaryButton(title: "Continue", action: #selector(confirmButtonTapped(_:)), topMargin: 11)
       ]
    }()

    init(interactor: ConfirmationCodeBusinessLogic, router: SSLRoutingLogic) {
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
    
    @objc func sendAgainButtonTapped(_ sender: UIButton) {
        //TODO
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        router.navigate(source: self, destination: .newPassword, data: nil)
    }
}



