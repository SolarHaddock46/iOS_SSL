//
//  ConfirmationCodeAssembly.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ConfirmationCodeAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = ConfirmationCodePresenter()
        let worker = ConfirmationCodeWorker()
        let interactor = ConfirmationCodeInteractor(presenter: presenter, worker: worker)
        let viewController = ConfirmationCodeViewController(interactor: interactor, router: router)

//        presenter.view = viewController

        return viewController
    }
}
