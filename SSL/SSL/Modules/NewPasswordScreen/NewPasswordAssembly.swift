//
//  ConfirmationCodeAssembly.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewPasswordAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = NewPasswordPresenter()
        let worker = NewPasswordWorker()
        let interactor = NewPasswordInteractor(presenter: presenter, worker: worker)
        let viewController = NewPasswordViewController(interactor: interactor, router: router)

//        presenter.view = viewController

        return viewController
    }
}
