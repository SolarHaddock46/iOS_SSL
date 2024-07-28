//
//  ConfirmationCodePresenter.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

final class ConfirmationCodePresenter: ConfirmationCodePresentationLogic {
    weak var view: ConfirmationCodeViewControllerProtocol?

    func presentInitForm(_ response: ConfirmationCode.InitForm.Response) {
//        view?.displayInitForm(ViewModel())
    }
}
