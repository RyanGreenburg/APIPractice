//
//  SpriteCollectionViewCell.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 1/10/21.
//

import UIKit

protocol NibInstantiable where Self: UIView {
    static var nibID: String { get }
    static var reuseID: String { get }
    static var nib: UINib { get }
}

extension NibInstantiable {
    static var nibID: String {
        return "\(Self.self)"
    }
    
    static var reuseID: String {
        return "\(Self.self)"
    }
    
    static var nib: UINib { UINib(nibName: Self.nibID, bundle: nil) }
}

class SpriteCollectionViewCell: UICollectionViewCell, NibInstantiable {

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
