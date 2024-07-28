//
//  ProfilePresenter.swift
//  SSL
//
//  Created by Владимир Мацнев on 28.07.2024.
//

import Foundation

final class ProfilePresenter: ProfilePresentationLogic {
    weak var view: ProfileViewControllerProtocol?

    func presentInitForm(_ response: Profile.InitForm.Response) {
//        view?.displayInitForm(ViewModel())
    }
}
