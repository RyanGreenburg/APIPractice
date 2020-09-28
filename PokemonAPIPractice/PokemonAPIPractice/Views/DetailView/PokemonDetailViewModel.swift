//
//  PokemonDetailViewModel.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import Foundation

struct PokemonDetailViewModel {
    enum Section: String, CaseIterable {
        case stats
        case moves
    }
    
    var pokemon: PokemonDetails
    var sprites: [String] {
        let spriteList = [pokemon.sprites.otherSprites.defaultSprite.frontDefault,
                          pokemon.sprites.frontDefault,
                          pokemon.sprites.backDefault,
                          pokemon.sprites.frontFemale,
                          pokemon.sprites.backFemale,
                          pokemon.sprites.frontShiny,
                          pokemon.sprites.backShiny,
                          pokemon.sprites.frontShinyFemale,
                          pokemon.sprites.backShinyFemale]
        
        return spriteList.compactMap { $0 }
    }
    
    var moves: [Move] {
        pokemon.moves.compactMap { $0.move }
    }
    
    var stats: [Stat] {
        pokemon.stats
    }
}
