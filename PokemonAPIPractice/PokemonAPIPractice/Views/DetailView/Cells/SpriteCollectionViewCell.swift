//
//  SpriteCollectionViewCell.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 1/10/21.
//

import UIKit

class SpriteCollectionViewCell: UICollectionViewCell {
    static let nib = UINib(nibName: "\(SpriteCollectionViewCell.self)", bundle: nil)
    static let reuseID = "\(SpriteCollectionViewCell.self)"

    @IBOutlet weak var spriteImageView: RequestingImageView!
    
    func configure(with string: String) {
        spriteImageView.contentMode = .scaleAspectFit
        spriteImageView.clipsToBounds = true
        spriteImageView.backgroundColor = .cyan
        self.addCornerRadius(self.bounds.height / 2)
        guard let url = URL(string: string) else { return }
        let request = URLRequest(url: url)
        spriteImageView.fetchAndSetImage(from: request)
    }
}
