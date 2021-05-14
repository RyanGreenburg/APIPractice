//
//  PokemonServiceTests.swift
//  PokemonAPIPracticeTests
//
//  Created by RYAN GREENBURG on 5/4/21.
//

import XCTest
@testable import PokemonAPIPractice

class PokemonServiceTests: XCTestCase {
    
}

struct MockPokemonService: PokemonFetchable {
    
    func fetch<T>(_ endpoint: PokemonEndpoint, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        let data =
    }
}
