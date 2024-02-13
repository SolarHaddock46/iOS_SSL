//
//  ViewController.swift
//  SSL
//
//  Created by Владимир Мацнев on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {

    private lazy var textField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: "a"), isSecure: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
