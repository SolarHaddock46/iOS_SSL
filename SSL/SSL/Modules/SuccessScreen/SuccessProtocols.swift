//
//  SuccessProtocols.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol SuccessDataStore {}

protocol SuccessBusinessLogic {
    func requestInitForm(_ request: Success.InitForm.Request)
}

protocol SuccessWorkerLogic {}

protocol SuccessPresentationLogic {
    func presentInitForm(_ response: Success.InitForm.Response)
}

protocol SuccessViewControllerProtocol: AnyObject {
//    func displayInitForm(_ viewModel: ViewModel)
}

protocol SuccessRoutingLogic {}
