//
//  PokemonService.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/23/20.
//

import Foundation

enum PokemonEndpoint {
    static let baseUrl = "https://pokeapi.co/api/v2"

    case ability
    case pokemon(Int)
    case pokemonList(Int)
    case type(Pokemon.PokemonType)
    
    var path: String {
        switch self {
        case .ability:
            return "ability"
        case .pokemonList:
            return "pokemon"
        case .pokemon(let index):
            return "pokemon/\(index)"
        case .type(let type):
            return "type/\(type.rawValue)"
        }
    }
    
    var url: URL? {
        guard var url = URL(string: PokemonEndpoint.baseUrl) else { return nil }
        
        switch self {
        case .pokemonList(let offset):
            url.appendPathComponent(path)
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [URLQueryItem(name: "offset", value: "\(offset)"),
                                       URLQueryItem(name: "limit", value: "\(20)")]
            return components?.url
        default:
            return url.appendingPathComponent(path)
        }
    }
}

protocol PokemonFetchable {
    func fetch<T: Decodable>(_ endpoint: PokemonEndpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

struct PokemonService: NetworkServicing, PokemonFetchable {
    func fetch<T: Decodable>(_ endpoint: PokemonEndpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        perform(urlRequest: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let decodedObjects = data.decode(type: T.self) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                completion(.success(decodedObjects))
            case .failure(let error):
                completion(.failure(.badRequest(error)))
            }
        }
    }
}
