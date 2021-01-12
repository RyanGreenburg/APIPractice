//
//  HeaderCollectionReusableView.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 1/11/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let nib = UINib(nibName: "\(HeaderCollectionReusableView.self)", bundle: nil)
    static let reuseID = "\(HeaderCollectionReusableView.self)"

    @IBOutlet weak var headerLabel: UILabel!
}
