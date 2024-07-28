//
//  SuccessViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 16.07.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class SuccessViewController: AuthTemplateViewController, SuccessViewControllerProtocol {
    private let interactor: SuccessBusinessLogic
    private let router: SSLRoutingLogic
    
    private lazy var successView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 18
        view.alignment = .leading
        return view
    }()
    
    private lazy var successImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "success")
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 32),
            view.heightAnchor.constraint(equalToConstant: 32)
        ])
        return view
    }()
    
    private lazy var successText: SSLLabel = {
        let label = SSLLabel(localizationKey: "Success", isHeading: true)
        return label
    }()
    
    private lazy var elements: [AuthContentElement] = {
        return [
            .customView(successView),
            .spacing(height: 28),
            .subtext(text: "Yay"),
            .spacing(height: 28),
            .primaryButton(title: "Close", action: #selector(closeButtonTapped(_:)))
        ]
    }()

    init(interactor: SuccessBusinessLogic, router: SSLRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView(withElements: elements)
        setupSuccessView()
    }
    
    private func setupSuccessView() {
        successView.addArrangedSubview(successImage)
        successView.addArrangedSubview(successText)
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
//        navigationController?.popToRootViewController(animated: true)
        router.navigate(source: self, destination: .profileView, data: nil)
    }
}
