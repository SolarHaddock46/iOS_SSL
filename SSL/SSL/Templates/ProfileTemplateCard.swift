//import UIKit
//
//enum ProfileCardContentElement: Hashable {
//    case nameLabel(text: String)
//    case spacing(height: CGFloat)
//    case dataButton(text: String, isSecure: Bool)
//    case customView(UIView)
//    
//    static func == (lhs: ProfileCardContentElement, rhs: ProfileCardContentElement) -> Bool {
//        switch (lhs, rhs) {
//        case (.nameLabel(let lhsText), .nameLabel(let rhsText)):
//            return lhsText == rhsText
//        case (.spacing(let lhsHeight), .spacing(let rhsHeight)):
//            return lhsHeight == rhsHeight
//        case (.dataButton(let lhsText, let lhsIsSecure), .dataButton(let rhsText, let rhsIsSecure)):
//            return lhsText == rhsText && lhsIsSecure == rhsIsSecure
//        case (.customView(let lhsView), .customView(let rhsView)):
//            return lhsView == rhsView
//        default:
//            return false
//        }
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .nameLabel(let text):
//            hasher.combine(text)
//        case .spacing(let height):
//            hasher.combine(height)
//        case .dataButton(let text, let isSecure):
//            hasher.combine(text)
//            hasher.combine(isSecure)
//        case .customView(let view):
//            hasher.combine(ObjectIdentifier(view))
//        }
//    }
//}
//
//class ProfileTemplateCard: UIView {
//    private let contentView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.backgroundColor = .white
//        stackView.layer.cornerRadius = 16
//        stackView.layer.shadowColor = UIColor.black.cgColor
//        stackView.layer.shadowOpacity = 0.1
//        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        stackView.layer.shadowRadius = 4
//        return stackView
//    }()
//    
//    private let horizontalPadding: CGFloat = 16
//    private let verticalPadding: CGFloat = 28
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupLayout()
//    }
//    
//    private func setupLayout() {
//        addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//    
//    func setupContentView(withElements elements: [ProfileCardContentElement]) {
//        elements.forEach { element in
//            let view: UIView
//            switch element {
//            case .nameLabel(let text):
//                view = createNameLabel(withText: text)
//            case .dataButton(let text, let isSecure):
//                view = createDataButton(withText: text, isSecure: isSecure)
//            case .customView(let customView):
//                view = customView
//            case .spacing(let height):
//                let spacerView = UIView()
//                spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
//                view = spacerView
//            }
//            contentView.addArrangedSubview(view)
//        }
//        contentView.layoutMargins = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//        contentView.isLayoutMarginsRelativeArrangement = true
//    }
//    
//    private func createNameLabel(withText text: String) -> UILabel {
//        let label = UILabel()
//        label.font = .onestMedium(ofSize: 24)
//        label.textColor = .mainTextColor
//        label.text = text
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        return label
//    }
//    
//    private func createDataButton(withText text: String, isSecure: Bool) -> UIView {
//        let buttonContainer = UIView()
//        
//        let textLabel = UILabel()
//        textLabel.font = .onestMedium(ofSize: 16)
//        textLabel.textColor = .mainTextColor
//        textLabel.text = isSecure ? String(repeating: "*", count: text.count) : text
//        
//        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
//        arrowImageView.contentMode = .scaleAspectFit
//        
//        buttonContainer.addSubview(textLabel)
//        buttonContainer.addSubview(arrowImageView)
//        
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            buttonContainer.heightAnchor.constraint(equalToConstant: 24),
//            
//            textLabel.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
//            textLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
//            
//            arrowImageView.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
//            arrowImageView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
//            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
//            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        
//        return buttonContainer
//    }
//    
//    private func createEditButton() -> UIButton {
//        let button = UIButton(type: .system)
//        
//        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
//        let editIcon = UIImage(systemName: "pencil", withConfiguration: configuration)
//        
//        button.setImage(editIcon, for: .normal)
//        button.tintColor = .buttonBackgroundColor
//        button.backgroundColor = .clear
//        
//        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
//        
//        return button
//    }
//    
//    @objc private func editButtonTapped() {
//        print("Edit button tapped.")
//    }
//    
//    func addEditButton() {
//        let editButton = createEditButton()
//        contentView.addSubview(editButton)
//        
//        editButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            editButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
//            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            editButton.widthAnchor.constraint(equalToConstant: 30),
//            editButton.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//}
