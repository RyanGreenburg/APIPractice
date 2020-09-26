//
//  NetworkServicing.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/23/20.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest(Error)
    case couldNotUnwrap
}

protocol NetworkServicing {
    typealias DataCompletion = (Result<Data, NetworkError>) -> Void
    func perform(urlRequest: URLRequest, completion: @escaping DataCompletion)
}

extension NetworkServicing {
    func perform(urlRequest: URLRequest, completion: @escaping DataCompletion) {
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.badRequest(error)))
            }
            
            guard let data = data else {
                completion(.failure(.couldNotUnwrap))
                return
            }
            
            DispatchQueue.main.async { completion(.success(data)) }
        }.resume()
    }
}

extension Data {
    func decode<T: Decodable>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        do {
            let object = try decoder.decode(T.self, from: self)
            return object
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
        return nil
    }
}
