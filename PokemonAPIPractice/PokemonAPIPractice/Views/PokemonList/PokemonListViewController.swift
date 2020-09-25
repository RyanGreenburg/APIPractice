//
//  PokemonListViewController.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class PokemonListViewController: UIViewController {
    private enum Section: CaseIterable {
        case main
    }
    
    private var activeRequestGroup = DispatchGroup()
    private var viewModel = PokemonListViewModel()
    private var dataSource: UITableViewDiffableDataSource<Section, Pokemon>?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateModelCollection()
        configureSearchController()
        dataSource = configureDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func configureDataSource() -> UITableViewDiffableDataSource<Section, Pokemon> {
        UITableViewDiffableDataSource<Section, Pokemon>(tableView: tableView) { (tableView, indexPath, pokemon) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell")
            cell?.textLabel?.text = pokemon.name.capitalized
            return cell
        }
    }
    
    private func populateModelCollection() {
        activeRequestGroup.enter()
        PokemonService().fetch(.pokemon(viewModel.offset)) { (result: Result<PokemonList, NetworkError>) in
            switch result {
            case.success(let list):
                let pokemon = list.results
                self.viewModel.collection.append(contentsOf: pokemon)
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
            self.activeRequestGroup.leave()
        }
        activeRequestGroup.notify(queue: .main) {
            self.updateDataSource(with: self.viewModel.collection)
        }
    }
    
    private func updateDataSource(with pokemon: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(pokemon, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search pokemon..."
        navigationItem.searchController = searchController
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

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row > viewModel.collection.count - 2 else { return }
        viewModel.offset += 20
        populateModelCollection()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.filteredResults.isEmpty {
            let selectedPokemon = viewModel.collection[indexPath.row]
            prepareDetailView(with: selectedPokemon)
        } else {
            let selectedPokemon = viewModel.filteredResults[indexPath.row]
            prepareDetailView(with: selectedPokemon)
        }
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.filteredResults = []
            updateDataSource(with: viewModel.collection)
            return
        }
        viewModel.searchTerm = searchText
        viewModel.filteredResults = viewModel.collection.filter { $0.name.contains(searchText.lowercased()) }
        updateDataSource(with: viewModel.filteredResults)
    }
}
