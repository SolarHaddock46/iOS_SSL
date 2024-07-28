//
//  ConfirmationCodeProtocols.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ConfirmationCodeDataStore {}

protocol ConfirmationCodeBusinessLogic {
    func requestInitForm(_ request: ConfirmationCode.InitForm.Request)
}

protocol ConfirmationCodeWorkerLogic {}

protocol ConfirmationCodePresentationLogic {
    func presentInitForm(_ response: ConfirmationCode.InitForm.Response)
}

protocol ConfirmationCodeViewControllerProtocol: AnyObject {
//    func displayInitForm(_ viewModel: ViewModel)
}

protocol ConfirmationCodeRoutingLogic {}
