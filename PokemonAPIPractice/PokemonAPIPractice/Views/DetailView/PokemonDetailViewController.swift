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
    private var detailsDataSource: UICollectionViewDiffableDataSource<PokemonDetailViewModel.Section, ListItem>?

    @IBOutlet weak var spriteCollectionView: UICollectionView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .firstItemInSection
        detailsCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        spriteDataSource = configureSpriteDataSource()
        spriteCollectionView.dataSource = spriteDataSource
        spriteCollectionView.collectionViewLayout = configureSpriteLayout()
        detailsDataSource = configureDetailsDataSource()
        detailsCollectionView.dataSource = detailsDataSource
        applyDetailsSnapshot()
        applySpriteSnapshot()
    }
}
    
// MARK: - SpriteCollectionView Configuration
extension PokemonDetailViewController {
    private enum ListItem: Hashable {
        case header(PokemonDetailViewModel.Section)
        case item(String)
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

// MARK: - DetailsCollecttionView Configuration
extension PokemonDetailViewController {
    
    private func configureDetailsDataSource() -> UICollectionViewDiffableDataSource<PokemonDetailViewModel.Section, ListItem> {
        let headerReg = sectionHeaderRegistration()
        let cellReg = cellRegistration()
        return UICollectionViewDiffableDataSource<PokemonDetailViewModel.Section, ListItem>(collectionView: detailsCollectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .header(let header):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerReg,
                                                                        for: indexPath,
                                                                        item: header)
                return cell
            case .item(let string):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg,
                                                             for: indexPath,
                                                             item: string)
                return cell
            }
        }
    }
    
    private func sectionHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PokemonDetailViewModel.Section> {
        UICollectionView.CellRegistration { cell, indexPath, type in
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = type.rawValue.capitalized
            cell.contentConfiguration = cellConfig
            
            let headerOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerOption)]
        }
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration { cell, indexPath, item in
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = item.capitalized
            cell.contentConfiguration = cellConfig
        }
    }
    
    private func applyDetailsSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PokemonDetailViewModel.Section, ListItem>()
        snapshot.appendSections(PokemonDetailViewModel.Section.allCases)
        detailsDataSource?.apply(snapshot)
        PokemonDetailViewModel.Section.allCases.forEach { section in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            let headerItem = ListItem.header(section)
            sectionSnapshot.append([headerItem])
            switch section {
            case .moves:
                let moves = viewModel?.moves.compactMap { ListItem.item($0.name) }
                sectionSnapshot.append(moves ?? [], to: headerItem)
            case .stats:
                let stats = viewModel?.stats.compactMap { ListItem.item("\($0.statInfo.name) : \($0.baseStat)") }
                sectionSnapshot.append(stats ?? [], to: headerItem)
            }
            sectionSnapshot.expand([headerItem])
            detailsDataSource?.apply(sectionSnapshot, to: section, animatingDifferences: false)
        }
    }
}
