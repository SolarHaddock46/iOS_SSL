//
//  ConfirmationCodePresenter.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

final class ForgotPasswordEmailPresenter: ForgotPasswordEmailPresenterProtocol {
    weak var view: ForgotPasswordEmailViewControllerProtocol?

    func presentInitForm(_ response: ForgotPasswordEmail.InitForm.Response) {
//        view?.displayInitForm(ViewModel())
    }
}
