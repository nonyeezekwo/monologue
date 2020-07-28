//
//  CategoryCollectionViewCell.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageBackground: UIImageView!

    var categoryImage: UIImageView!
    var categoryLabel: UILabel!
    var scriptCountLabel: UILabel!

    var count = 0

//    var monologues: [Monologue]? {
//        didSet {
//            updateUI()
//        }
//    }
//
    var category: Category! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        if let category = category {
            featuredImageBackground.image = category.featuredImage
        } else {
            featuredImageBackground.image = nil
        }
//        guard let category = category else { return }
//
//        categoryImage.image = UIImage(named: category.rawValue.lowercased())
//        categoryLabel.text = category.rawValue.capitalized
//        scriptCountLabel.isHidden = true
//    }
    
}
}




