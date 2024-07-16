//
//  ConfirmationCodeAssembly.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ForgotPasswordEmailAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = ForgotPasswordEmailPresenter()
        let worker = ForgotPasswordEmailWorker()
        let interactor = ForgotPasswordEmailInteractor(presenter: presenter, worker: worker)
        let viewController = ForgotPasswordEmailViewController(interactor: interactor, router: router)

//        presenter.view = viewController

        return viewController
    }
}
