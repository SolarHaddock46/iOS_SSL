//
//  SuccessAssembly.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SuccessAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = SuccessPresenter()
        let worker = SuccessWorker()
        let interactor = SuccessInteractor(presenter: presenter, worker: worker)
        let viewController = SuccessViewController(interactor: interactor, router: router)

//        presenter.view = viewController

        return viewController
    }
}
