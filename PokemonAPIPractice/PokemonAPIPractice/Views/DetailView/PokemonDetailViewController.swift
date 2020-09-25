//
//  PokemonDetailViewController.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    private enum Section: CaseIterable {
        case main
    }
    
    var viewModel: PokemonDetailViewModel?
    private var spriteDataSource: UICollectionViewDiffableDataSource<Section, String>?

    @IBOutlet weak var spriteCollectionView: UICollectionView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spriteDataSource = configureSpriteDataSource()
        spriteCollectionView.dataSource = spriteDataSource
        spriteCollectionView.collectionViewLayout = configureSpriteLayout()
        applySpriteSnapshot()
    }
    
    private func configureSpriteDataSource() -> UICollectionViewDiffableDataSource<Section, String> {
        UICollectionViewDiffableDataSource<Section, String>(collectionView: spriteCollectionView) { (collectionView, indexPath, string) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spriteCell", for: indexPath) as? SpriteCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(with: string)
            
            return cell
        }
    }
    
    private func configureSpriteLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.8), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func applySpriteSnapshot() {
        guard let model = viewModel else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(model.sprites, toSection: .main)
        spriteDataSource?.apply(snapshot)
    }
}
