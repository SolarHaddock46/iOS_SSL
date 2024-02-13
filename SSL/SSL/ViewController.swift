//
//  ViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {

    private lazy var primaryButton = PrimaryButton(localizationKey: "Sign up")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(primaryButton)
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        primaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        primaryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
