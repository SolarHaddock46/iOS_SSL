//
//  SuccessInteractor.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

final class SuccessInteractor: SuccessBusinessLogic, SuccessDataStore {
    private let presenter: SuccessPresentationLogic
    private let worker: SuccessWorkerLogic

    init(
        presenter: SuccessPresentationLogic,
        worker: SuccessWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func requestInitForm(_ request: Success.InitForm.Request) {
        DispatchQueue.main.async {
            self.presenter.presentInitForm(Success.InitForm.Response())
        }
    }
}
