//
//  ConfirmationCodeInteractor.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

final class ForgotPasswordEmailInteractor: ForgotPasswordEmailBusinessLogic, ForgotPasswordEmailDataStore {
    private let presenter: ForgotPasswordEmailPresenterProtocol
    private let worker: ForgotPasswordEmailWorkerLogic

    init(
        presenter: ForgotPasswordEmailPresenterProtocol,
        worker: ForgotPasswordEmailWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func requestInitForm(_ request: ForgotPasswordEmail.InitForm.Request) {
        DispatchQueue.main.async {
            self.presenter.presentInitForm(ForgotPasswordEmail.InitForm.Response())
        }
    }
}
