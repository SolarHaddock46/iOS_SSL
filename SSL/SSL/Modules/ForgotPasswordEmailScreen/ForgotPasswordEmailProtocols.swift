//
//  ConfirmationCodeProtocols.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForgotPasswordEmailDataStore {}

protocol ForgotPasswordEmailBusinessLogic {
    func requestInitForm(_ request: ForgotPasswordEmail.InitForm.Request)
}

protocol ForgotPasswordEmailWorkerLogic {}

protocol ForgotPasswordEmailPresenterProtocol {
    func presentInitForm(_ response: ForgotPasswordEmail.InitForm.Response)
}

protocol ForgotPasswordEmailViewControllerProtocol: AnyObject {
//    func displayInitForm(_ viewModel: ViewModel)
}

protocol ForgotPasswordEmailRoutingLogic {}
