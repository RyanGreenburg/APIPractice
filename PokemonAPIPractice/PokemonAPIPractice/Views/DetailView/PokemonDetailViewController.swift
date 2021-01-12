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
    private lazy var detailsDataSource = {
        PokemonDetailDataSource(collectionView: detailsCollectionView)
    }()

    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsCollectionView.dataSource = detailsDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = viewModel else { return }
        title = model.title
        navigationController?.navigationBar.prefersLargeTitles = true
        detailsDataSource.applyData(with: model)
    }
}
