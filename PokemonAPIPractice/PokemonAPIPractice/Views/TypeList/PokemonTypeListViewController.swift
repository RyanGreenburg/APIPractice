//
//  PokemonTypeListViewController.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class PokemonTypeListViewController: UIViewController {
    
    private enum ListItem: Hashable {
        case header(Pokemon.PokemonType)
        case pokemon(TypePokemon)
    }
    
    var activeFetchGroup = DispatchGroup()
    var model = PokemonTypeListViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Pokemon.PokemonType, ListItem>?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        dataSource = configureDataSource()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        populateModelCollection()
        
    }
    
    private func populateModelCollection() {
        Pokemon.PokemonType.allCases.forEach { type in
            activeFetchGroup.enter()
            PokemonService().fetch(.type(type)) { (result: Result<Type, NetworkError>) in
                switch result {
                case .success(let foundType):
                    self.model.collection[type] = foundType.results
                case .failure(let error):
                    print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                }
                self.activeFetchGroup.leave()
            }
        }
        activeFetchGroup.notify(queue: .main) {
            self.updateDataSource()
        }
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Pokemon.PokemonType, ListItem> {
        let headerReg = sectionHeaderRegistration()
        let cellReg = cellRegistration()
        return UICollectionViewDiffableDataSource<Pokemon.PokemonType, ListItem>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .header(let header):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerReg,
                                                                        for: indexPath,
                                                                        item: header)
                return cell
            case .pokemon(let pokemon):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg,
                                                             for: indexPath,
                                                             item: pokemon)
                return cell
            }
        }
    }

    private func sectionHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Pokemon.PokemonType> {
        UICollectionView.CellRegistration { cell, indexPath, type in
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = type.rawValue.capitalized
            cell.contentConfiguration = cellConfig
            
            let headerOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerOption)]
        }
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, TypePokemon> {
        UICollectionView.CellRegistration { cell, indexPath, pokemon in
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = pokemon.pokemon.name.capitalized
            cell.contentConfiguration = cellConfig
        }
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Pokemon.PokemonType, ListItem>()
        snapshot.appendSections(Pokemon.PokemonType.allCases)
        dataSource?.apply(snapshot)
        Pokemon.PokemonType.allCases.forEach { type in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            let headerItem = ListItem.header(type)
            sectionSnapshot.append([headerItem])
            let pokemon = model.collection[type]
            let pokemonListItems = pokemon?.map { ListItem.pokemon($0) }
            sectionSnapshot.append(pokemonListItems ?? [], to: headerItem)
            dataSource?.apply(sectionSnapshot, to: type, animatingDifferences: false)
        }
    }
}

extension PokemonTypeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        let section = Pokemon.PokemonType.allCases[indexPath.section]
        guard let selectedPokemon = model.collection[section]?[indexPath.row].pokemon else { return }
        prepareDetailView(with: selectedPokemon)
    }
    
    private func prepareDetailView(with selectedPokemon: Pokemon) {
        guard let url = URL(string: selectedPokemon.url) else { return }
        let request = URLRequest(url: url)
        PokemonService().perform(urlRequest: request) { result in
            switch result {
            case .success(let data):
                guard let pokemon = data.decode(type: PokemonDetails.self) else { return }
                let model = PokemonDetailViewModel(pokemon: pokemon)
                let storyboard = UIStoryboard(name: "PokemonDetailViewController", bundle: nil)
                guard let vc = storyboard.instantiateInitialViewController() as? PokemonDetailViewController else { return }
                vc.viewModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}
