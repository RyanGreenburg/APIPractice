//
//  Sprites.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/26/20.
//

import Foundation

struct Sprites: Decodable, Hashable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let otherSprites: OtherSprites
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_detail"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case otherSprites = "other"
    }
}

struct OtherSprites: Decodable, Hashable {
    let defaultSprite: DefaultSprite
    let dreamWorldSprite: DreamWorldSprite
    
    enum CodingKeys: String, CodingKey {
        case defaultSprite = "official-artwork"
        case dreamWorldSprite = "dream_world"
    }
}

struct DefaultSprite: Decodable, Hashable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct DreamWorldSprite: Decodable, Hashable {
    let frontDefault: String
    let frontFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
    }
}
