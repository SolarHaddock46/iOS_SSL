//
//  ConfirmationCodeProtocols.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol NewPasswordDataStore {}

protocol NewPasswordBusinessLogic {
    func requestInitForm(_ request: NewPassword.InitForm.Request)
}

protocol NewPasswordWorkerLogic {}

protocol NewPasswordPresenterProtocol {
    func presentInitForm(_ response: NewPassword.InitForm.Response)
}

protocol NewPasswordViewControllerProtocol: AnyObject {
//    func displayInitForm(_ viewModel: ViewModel)
}

protocol NewPasswordRoutingLogic {}
