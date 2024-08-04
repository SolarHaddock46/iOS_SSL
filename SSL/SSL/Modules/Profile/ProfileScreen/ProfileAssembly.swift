import Foundation
import UIKit

enum ProfileAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(presenter: presenter)
        let viewController = ProfileViewController(interactor: interactor, router: router)
        presenter.viewController = viewController // Add this line
        return viewController
    }
    
    static func createCollectionView() -> UICollectionView {
       let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
           section.interGroupSpacing = 20
           return section
       }

       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.backgroundColor = .clear
       return collectionView
   }
}
