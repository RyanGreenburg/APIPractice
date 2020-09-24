//
//  PokemonListViewModel.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import Foundation

struct PokemonListViewModel {
    var offset: Int = 0
    var collection = [Pokemon]()
    var searchTerm: String? = nil
    var filteredResults = [Pokemon]()
}
