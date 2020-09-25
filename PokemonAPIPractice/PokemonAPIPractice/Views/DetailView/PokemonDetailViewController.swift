//
//  PokemonDetailViewController.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    var viewModel: PokemonDetailViewModel?
    var pokemon: PokemonDetails?

    @IBOutlet weak var spriteCollectionView: UICollectionView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pokemon = pokemon else { return }
        viewModel = PokemonDetailViewModel(pokemon: pokemon)
        

    }
    
    
}
