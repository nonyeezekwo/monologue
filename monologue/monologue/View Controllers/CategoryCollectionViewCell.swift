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
    
    
    var category: Category!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let category = category{
            featuredImageBackground.image = category.featuredImage
        }
    }
    
    
    
}
