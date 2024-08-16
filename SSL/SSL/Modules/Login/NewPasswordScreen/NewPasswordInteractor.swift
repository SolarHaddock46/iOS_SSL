//
//  ConfirmationCodeInteractor.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

final class NewPasswordInteractor: NewPasswordBusinessLogic, NewPasswordDataStore {
    private let presenter: NewPasswordPresenterProtocol
    private let worker: NewPasswordWorkerLogic

    init(
        presenter: NewPasswordPresenterProtocol,
        worker: NewPasswordWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func requestInitForm(_ request: NewPassword.InitForm.Request) {
        DispatchQueue.main.async {
            self.presenter.presentInitForm(NewPassword.InitForm.Response())
        }
    }
}
