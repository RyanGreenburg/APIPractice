//
//  PokemonDetailDataSource.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 1/9/21.
//

import UIKit

struct Section: Hashable {
    let title: String?
    var items: [Item]
}

enum ListItem: Hashable {
    case header(Section)
    case item(String)
}

struct Item: Hashable {
    enum Context: Hashable {
        case heroImage(String)
        case swimlane(String)
        case list(ListItem)
    }
    
    let context: Context
}

class PokemonDetailDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    // MARK: - Class Properties
    private static var listHeaderCellConfiguration: UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration { cell, indexPath, item in
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = item.capitalized
            cell.contentConfiguration = cellConfig
        }
    }
    
    private static var listItemCellConfiguration: UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration { cell, indexPath, item in
            var cellConfiguration = cell.defaultContentConfiguration()
            cellConfiguration.text = item.capitalized
            cell.contentConfiguration = cellConfiguration
        }
    }
    
    // MARK: - Init
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item.context {
            case .heroImage(let string), .swimlane(let string):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpriteCollectionViewCell.reuseID, for: indexPath) as? SpriteCollectionViewCell
                
                cell?.configure(with: string)
                                
                return cell
            case .list(let listItem):

                switch listItem {
                case .header(let header):
                    
                    let cell = collectionView.dequeueConfiguredReusableCell(using: Self.listHeaderCellConfiguration, for: indexPath, item: header.title)
                    
                    return cell
                case .item(let item):
                    
                    let cell = collectionView.dequeueConfiguredReusableCell(using: Self.listItemCellConfiguration, for: indexPath, item: item)
                    
                    return cell
                }
            }
        }
        
        supplementaryViewProvider = { (collectionView: UICollectionView,
                                       kind: String,
                                       indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as? HeaderCollectionReusableView else { fatalError() }
            
            headerView.headerLabel.text = self.snapshot().sectionIdentifiers[indexPath.section].title
            
            return headerView
        }
        
        registerCells(for: collectionView)
        collectionView.collectionViewLayout = configureLayout()
    }

    // MARK: - Methods
    
    private func registerCells(for collectionView: UICollectionView) {
        collectionView.register(SpriteCollectionViewCell.nib, forCellWithReuseIdentifier: SpriteCollectionViewCell.reuseID)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: "header", withReuseIdentifier: HeaderCollectionReusableView.reuseID)
    }
    
    func applyData(with model: PokemonDetailViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        /// Hero Image
        let heroImageItem = Item(context: .heroImage(model.heroImage))
        let heroImageSection = Section(title: model.title, items: [heroImageItem])
        /// Sprites Swimlane
        let spriteItems = model.sprites.compactMap { Item(context: .swimlane($0)) }
        let spriteSwimlaneSection = Section(title: "Sprites", items: spriteItems)
        
        var sections = [heroImageSection, spriteSwimlaneSection]
        
        /// Moves and Stats lists
        PokemonDetailViewModel.Info.allCases.forEach { category in
            var section = Section(title: category.rawValue.capitalized, items: [])

            let headerItem = Item(context: .list(.header(section)))
            section.items.append(headerItem)
            
            switch category {
            case .stats:
                let stats = model.stats.compactMap {
                    Item(context: .list(.item("\($0.statInfo.name) : \($0.baseStat)")))
                }

                section.items.append(contentsOf: stats)

            case .moves:
                let moves = model.moves.compactMap {
                    Item(context: .list(.item($0.name)))
                }
                section.items.append(contentsOf: moves)
            }
            
            sections.append(section)
        }
        
        snapshot.appendSections(sections)
        
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        apply(snapshot)
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            var configuredSection: NSCollectionLayoutSection!
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 20,
                                              leading: 20,
                                              bottom: 20,
                                              trailing: 20)
                
                configuredSection = section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(5)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 20,
                                              leading: 20,
                                              bottom: 20,
                                              trailing: 20)
                
                configuredSection = section
            default:
                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                configuration.headerMode = .firstItemInSection
                
                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
                
                configuredSection = section
            }
            
            return configuredSection
        }
                
        return layout
    }
}
