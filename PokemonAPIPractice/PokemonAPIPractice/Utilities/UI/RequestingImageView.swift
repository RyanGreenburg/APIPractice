//
//  RequestingImageView.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/28/20.
//

import UIKit

class RequestingImageView: UIImageView {

    func fetchAndSetImage(from urlRequest: URLRequest) {
        PokemonService().perform(urlRequest: urlRequest) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self?.image = image
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}
