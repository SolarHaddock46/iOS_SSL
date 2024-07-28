//
//  ConfirmationCodeInteractor.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

final class ConfirmationCodeInteractor: ConfirmationCodeBusinessLogic, ConfirmationCodeDataStore {
    private let presenter: ConfirmationCodePresentationLogic
    private let worker: ConfirmationCodeWorkerLogic

    init(
        presenter: ConfirmationCodePresentationLogic,
        worker: ConfirmationCodeWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func requestInitForm(_ request: ConfirmationCode.InitForm.Request) {
        DispatchQueue.main.async {
            self.presenter.presentInitForm(ConfirmationCode.InitForm.Response())
        }
    }
}
