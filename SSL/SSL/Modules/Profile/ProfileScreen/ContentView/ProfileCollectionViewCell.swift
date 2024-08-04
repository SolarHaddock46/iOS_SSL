import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    private var content: ProfileContentView?

    func configure(with item: ProfileViewController.Item) {
        content?.removeFromSuperview()

        var elements: [ProfileCardContentElement]

        switch item {
        case .nameCard(let elems):
            elements = elems + [.customView(createEditButton())]
        case .dataCard(let elems),
             .textFieldCard(let elems),
             .buttonCard(let elems):
            elements = elems
        case .logoutButton:
            elements = [
                .button(id: "logoutButton", text: "Log out")
            ]
        }

        let newContent = ProfileContentView(elements: elements)
        content = newContent
        contentView.addSubview(newContent)

        newContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newContent.topAnchor.constraint(equalTo: contentView.topAnchor),
            newContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func createEditButton() -> UIView {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let editIcon = UIImage(systemName: "pencil", withConfiguration: configuration)
        button.setImage(editIcon, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24)
        ])

        return containerView
    }

    @objc private func editButtonTapped() {
        NotificationCenter.default.post(name: .editButtonTapped, object: nil)
    }
}
