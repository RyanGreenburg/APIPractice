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

struct PokemonDetails: Decodable, Hashable {
    let name: String
    let sprites: Sprites
    let moves: [Moves]
    let stats: [Stat]
}

struct Sprites: Decodable, Hashable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_detail"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

struct Moves: Decodable, Hashable {
    let move: Move
}

struct Move: Decodable, Hashable {
    let name: String
    let url: String
}

struct Stat: Decodable, Hashable {
    let baseStat: Int
    let statName: StatName
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case statName = "stat"
    }
}

struct StatName: Decodable, Hashable {
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

