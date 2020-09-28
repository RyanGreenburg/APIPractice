//
//  SpriteCollectionViewCell.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 9/24/20.
//

import UIKit

class SpriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var spriteImageView: RequestingImageView!
    
    
    func configure(with string: String) {
        spriteImageView.contentMode = .scaleAspectFit
        guard let url = URL(string: string) else { return }
        let request = URLRequest(url: url)
        spriteImageView.fetchAndSetImage(from: request)
    }
}
