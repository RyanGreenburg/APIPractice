//
//  SpriteCollectionViewCell.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class SpriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var spriteImageView: UIImageView!
    
    
    func configure(with string: String) {
        guard let url = URL(string: string) else { return }
        let request = URLRequest(url: url)
        PokemonService().perform(urlRequest: request) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.spriteImageView.image = image
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}
