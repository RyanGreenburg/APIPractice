//
//  Pokemon.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/23/20.
//

import Foundation

struct PokemonList: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable, Hashable {
    enum PokemonType: String, CaseIterable {
        case normal
        case fighting
        case flying
        case poison
        case ground
        case rock
        case bug
        case ghost
        case steel
        case fire
        case water
        case grass
        case electric
        case psychic
        case ice
        case dragon
        case dark
        case fairy
    }
    
    let name: String
    let url: String
}

struct Type: Decodable {
    let name: String
    let results: [TypePokemon]
    
    enum CodingKeys: String, CodingKey {
        case name
        case results = "pokemon"
    }
}

struct TypePokemon: Decodable, Hashable {
    let pokemon: Pokemon
}
